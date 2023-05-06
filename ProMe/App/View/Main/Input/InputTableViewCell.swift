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
    
    var ID:String!
    
    func setupCell(title: String) {
        textView.delegate = self
        ID = title
        titleLabel.text = title
    }
    
}

extension InputTableViewCell: UITextViewDelegate {
    // 打ち込まれた内容を常に保存する
    func textViewDidChange(_ textView: UITextView) {
        print(ID)
        print(textView.text)
    }
}
