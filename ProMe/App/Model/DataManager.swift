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
    
    struct MessageData: Codable {
        var situation: SituationType
        var text: String
        var date: String
    }
    
    private let KEY_saveMessages = "KEY_saveMessages"
    public var messageHistory: [MessageData]? {
        get{
            let jsonDecoder = JSONDecoder()
            let data = userDefaults.data(forKey: KEY_saveMessages) ?? Data()
            guard let lists = try? jsonDecoder.decode([MessageData].self, from: data) else{
                return nil
            }
            return lists
        }
        set(v){
            var list = v!
            if 10 < list.count {
                list.remove(at: 0)
            }
            let jsonEncoder = JSONEncoder()
            guard let data = try? jsonEncoder.encode(list) else { return }
            userDefaults.set(data ,forKey: KEY_saveMessages)}
        }
    // GPTに送信する用
    public var messagesForGPT: [MockMessage] = []
    }
    
    
    
//    // GPTに送信する用
//    public var messagesForGPT: [MockMessage] = []
//
//    struct SaveMessage: Codable {
//        let situationType: SituationType
//        let messages: [String]
//        let date: String
//    }
//    private let KEY_saveMessages = "KEY_saveMessages"
//    public var saveMessages: [SaveMessage]? {
//        get{
//            let jsonDecoder = JSONDecoder()
//            let data = userDefaults.data(forKey: KEY_saveMessages) ?? Data()
//            guard let lists = try? jsonDecoder.decode([SaveMessage].self, from: data) else{
//                return nil
//            }
//            return lists
//
//        }
//        set(v){
//            let jsonEncoder = JSONEncoder()
//            guard let data = try? jsonEncoder.encode(v!) else { return }
//            userDefaults.set(data ,forKey: KEY_saveMessages)}
//    }
//}
