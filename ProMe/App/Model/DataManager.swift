//
//  DataManager.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/02.
//

import Foundation

final class DataManager {
    static let singleton = DataManager() // シングルトン・インタンス
    
    public var chatMessages: [MockMessage] = []
    
    public var myInfos:[String:String] = [:]
    public func getMyInfo() -> String {
        var text = ""
        for item in myInfos {
            text += item.value
        }
        return text
    }
}
