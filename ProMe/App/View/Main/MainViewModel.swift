//
//  MainViewModel.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/06.
//

//WARNING// import UIKit 等UI関係は実装しない
import Foundation

class MainViewModel {
    
    let mainTableViewCellContents:[MainTableViewCellContent] = [
        MainTableViewCellContent(type: .input, title: "自己PRにしたい出来事", placeHolderText: nil),
        MainTableViewCellContent(type: .input, title: "出来事に対して困ったこと", placeHolderText: nil),
        MainTableViewCellContent(type: .input, title: "解決方法", placeHolderText: nil),
        MainTableViewCellContent(type: .input, title: "何を学んだか", placeHolderText: nil)]
    
    
}
