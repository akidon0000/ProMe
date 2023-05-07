//
//  HistoryViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/07.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション内のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath ) as! HistoryTableViewCell
        inputCell.setupCell(contents: "aaa", date: "bbb", type: "ccc")
        return inputCell
    }
    
}
