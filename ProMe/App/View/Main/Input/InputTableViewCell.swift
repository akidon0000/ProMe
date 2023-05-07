//
//  InputTableViewCell.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/06.
//

import UIKit

class InputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    let dataManager = DataManager.singleton
    var ID:String!
    
    func setupCell(title: String, contents: String) {
        textView.delegate = self
        ID = title
        titleLabel.text = title
        textView.text = contents
    }
    
}

extension InputTableViewCell: UITextViewDelegate {
    // 打ち込まれた内容を常に保存する
    func textViewDidChange(_ textView: UITextView) {
        dataManager.textGenerationUserInfo[ID] = textView.text
    }
}
