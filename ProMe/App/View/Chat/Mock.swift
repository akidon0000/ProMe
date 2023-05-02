//
//  Mock.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/02.
//

import MessageKit
import UIKit
import InputBarAccessoryView

struct User: SenderType {
    var senderId: String
    let displayName: String
}

enum userType {
    case me
    case you

    var data: SenderType {
        switch self {
        case .me:
            return User(senderId: "001", displayName: "あなた")
        case .you:
            return User(senderId: "002", displayName: "AIアドバイザー：Akidon")
        }
    }
}

struct MockMessage: MessageType {

    var messageId: String
    var sender: SenderType
    var sentDate: Date
    var kind: MessageKind

    private init(kind: MessageKind, sender: SenderType, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }

    init(text: String, sender: SenderType, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }

    init(attributedText: NSAttributedString, sender: SenderType, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }

    // サンプル用に適当なメッセージ
    static func getMessages() -> [MockMessage] {
        return DataManager.singleton.chatMessages
    }

    static func createMessage(text: String, user: userType) -> MockMessage {
        let attributedText = NSAttributedString(
            string: text,
            attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]
        )
        return MockMessage(attributedText: attributedText, sender: user.data, messageId: UUID().uuidString, date: Date())
    }
}
