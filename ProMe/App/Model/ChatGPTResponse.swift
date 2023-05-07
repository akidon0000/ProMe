//
//  ChatGPTResponse.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import Foundation

struct ChatGPTResponse: Codable {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [Choice]
    var usage: Usage

    struct Choice: Codable {
        var index: Int
        var finish_reason: String
        var message: Message

        struct Message: Codable {
            var role: String
            var content: String
        }
    }

    struct Usage: Codable {
        var prompt_tokens: Int
        var completion_tokens: Int
        var total_tokens: Int
    }
}
