//
//  DataManager.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/02.
//

import Foundation

final class DataManager {
    
    static let singleton = DataManager() // シングルトン・インタンス
    private var userDefaults = UserDefaults.standard
    
    // Main画面で記入したユーザーの内容[質問内容：ユーザーの回答]
    
    public var textGenerationUserInfo = OrderedDictionary<String, String>()
    
    public func fetchUserInfo() -> String {
        var text = ""
        for i in 0 ..< textGenerationUserInfo.count {
            text += textGenerationUserInfo.value(at: i) ?? "" + "。 "
        }
        return text
    }
    
    // GPTに送信する用
    public var messagesForGPT: [MockMessage] = []
    
    struct SaveMessage: Codable {
        let situationType: SituationType
        let messages: [String]
    }
    private let KEY_saveMessages = "KEY_saveMessages"
    public var saveMessages: [SaveMessage]? {
        get{
            let jsonDecoder = JSONDecoder()
            let data = userDefaults.data(forKey: KEY_saveMessages) ?? Data()
            guard let lists = try? jsonDecoder.decode([SaveMessage].self, from: data) else{
                return nil
            }
            return lists
            
        }
        set(v){
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(v!) else { return }
            userDefaults.set(data ,forKey: KEY_saveMessages)}
    }
}
