//
//  ChatViewModel.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation
import Alamofire
import SwiftyJSON

struct Message: Hashable {
    var content: String
    var role: Role

    enum Role: String {
        case system = "system"
        case user = "user"
        case assistant = "assistant"
    }
}

class ChatViewModel {

    public var checkGPTConnectivity: (() -> Void)?
    private let dataManager = DataManager.singleton

    private let setting: Message? = Message(
        content: "",
        role: .system
    )

    @Published public var messages: [Message] = []
    @Published public var isAsking: Bool = false
    @Published public var errorText: String = ""
    @Published public var showAlert = false

    public func askChatGPT(text: String) {
        if text.isEmpty { return }
        isAsking = true
        add(text: text, role: .user)
        send(text: text)
    }

    private func responseSuccess(data: ChatGPTResponse) {
        guard let message = data.choices.first?.message else { return }
        add(text: message.content, role: .assistant)
        
        dataManager.messagesForGPT.removeAll()
        for message in messages {
            if message.role == .user {
                let str = MockMessage.createMessage(text: message.content, user: .me)
//                if dataManager.chatMessages.count != 0 {
                    dataManager.messagesForGPT.append(str)
//                }
            }else{
                let str = MockMessage.createMessage(text: message.content, user: .you)
                dataManager.messagesForGPT.append(str)
            }
        }
        
        checkGPTConnectivity?()
        isAsking = false
    }

    private func responseFailure(error: String) {
        errorText = error
        showAlert = true
        isAsking = false
    }

    private func add(text: String, role: Message.Role) {
        messages.append(.init(content: text, role: role))
    }
}


extension ChatViewModel {
    private func send(text: String) {
        let token = loadPlist(path: "key", key: "GPT-API-Token")
        let headers: HTTPHeaders = [
            "Content-type": "application/json",
            "Authorization":"Bearer \(token)"
        ]

        var messages = convertToMessages(text: text)
        if setting != nil {
            messages.insert(["content":setting!.content, "role":setting!.role.rawValue], at: 0)
        }
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
        ]
        
        let url = "https://api.openai.com/v1/chat/completions"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.timeoutInterval = 100 // タイムアウト時間を10秒に設定
        request.allHTTPHeaderFields = headers.dictionary
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])


        AF.request(request).responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                guard let res = try? JSONDecoder().decode(ChatGPTResponse.self, from: data) else {
                    self.responseFailure(error: "Decode error")
                    return
                }
                self.responseSuccess(data: res)
                break
            case .failure(let error):
                self.responseFailure(error: error.localizedDescription)
                break
            }
        })
    }
    
    // MARK: - Private func
    
    private func convertToMessages(text: String) -> [[String: String]] {
        return messages.map { ["content": $0.content, "role": $0.role.rawValue] }
    }
    
    /// plistを読み込み
    private func loadPlist(path: String, key: String) -> String{
        let filePath = Bundle.main.path(forResource: path, ofType:"plist")
        let plist = NSDictionary(contentsOfFile: filePath!)

        guard let pl = plist else{
            AKLog(level: .ERROR, message: "plistが存在しません")
            return ""
        }
        return pl[key] as! String
    }
}
