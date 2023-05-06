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
    
    func setupCell(title: String) {
        titleLabel.text = title
    }
    
}
