//
//  HistoryViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/07.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    public var delegate = ViewController()
    
    private let dataManager = DataManager.singleton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション内のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.messageHistory?.count ?? 0
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath ) as! HistoryTableViewCell
        if let item = dataManager.messageHistory?[indexPath.row] {
            inputCell.setupCell(contents: item.text, date: item.date, type: item.situation.rawValue)
        }
        return inputCell
    }
    
    /// セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dataManager.messageHistory?[indexPath.row] {
            dismiss(animated: true, completion: {
                self.delegate.situationMenuType = item.situation
                self.delegate.contentsTextView.text = item.text
                self.delegate.contentsTextView.placeHolder = ""
                self.delegate.situationButton.setTitle(item.situation.rawValue, for: .normal)
                self.delegate.titleLabel.text = self.delegate.viewModel.titleLabel[item.situation]
            })
        }
    }
}
