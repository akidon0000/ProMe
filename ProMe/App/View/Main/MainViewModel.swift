//
//  MainViewModel.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/06.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

class MainViewModel {
    
    public let titleLabel:[SituationType:String] = [
        .selfPromote:"""
PRしたい出来事
出来事に対して困ったこと
出来事に対しての行動
出来事から得た学び
""",
        .extracurricularActivities: "こんばんは"]
    
    public let placeHolderContents:[SituationType:String] = [
        .selfPromote:"""
PRしたい出来事
出来事に対して困ったこと
出来事に対しての行動
出来事から得た学び
""",
        .extracurricularActivities: "こんばんは"
    ]
    
}
