//
//  MainViewModel.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/06.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

class MainViewModel {
    
    enum SelfPRQuestion: String {
        case event = "PRしたい出来事"
        case trouble = "出来事に対して困ったこと"
        case action = "出来事に対しての行動"
        case learn = "出来事から得た学び"
    }
    
    enum GakutikaQuestion: String {
        case event = "学生時代に力を入れたこと"
        case trouble = "出来事に対して困ったこと"
        case action = "出来事に対しての行動"
        case learn = "出来事から得た学び"
    }
        
    let contentsSelfPromotion: [SituationType:[String]] = [
        .selfPromote:
            ["自己PRにしたい出来事",
             "出来事に対して困ったこと",
             "解決方法",
             "何を学んだか"],
        
            .extracurricularActivities:["test"]]
    
    
    
    
}
