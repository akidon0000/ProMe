//
//  HistoryTableViewCell.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/07.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var contentsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func setupCell(contents: String, date: String, type: String) {
        contentsLabel.text = contents
        dateLabel.text = date
        typeLabel.text = type
    }
}
