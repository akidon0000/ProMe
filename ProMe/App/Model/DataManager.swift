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
    public var textGenerationUserInfo:[String:String] = [:]
    
    public func fetchUserInfo() -> String {
        var text = ""
        for item in textGenerationUserInfo {
            text += item.value + "。 "
        }
        return text
    }
    
    // GPTに送信する用
    public var messagesForGPT: [MockMessage] = []
    
    private let KEY_messagesHistory = "KEY_messagesHistory"
    // メッセージの会話履歴を保存する
    public var messagesHistory: [UUID:[MockMessage]]{
        get{ return self.messagesHistory }
        set(v){ userDefaults.set(v ,forKey: KEY_messagesHistory) }
    }
    
//    private let KEY_messagesTypeHistory = "KEY_messagesTypeHistory"
    // メッセージの会話タイプ履歴を保存する
//    public var messagesTypeHistory: [UUID:]{
//        get{ return self.messagesTypeHistory }
//        set(v){ userDefaults.set(v ,forKey: KEY_messagesTypeHistory) }
//    }
}
