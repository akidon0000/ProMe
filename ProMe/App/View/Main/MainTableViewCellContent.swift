//
//  MainState.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/06.
//

import Foundation

enum CellType {
    case title
    case input
    case button
}

struct MainTableViewCellContent {
    let type: CellType
    let title: String?
    let placeHolderText: String?
}

