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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.messageHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /// messageHistoryは配列順序を反転して出力する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath ) as! HistoryTableViewCell
        guard let messageHistory = dataManager.messageHistory else{
            return inputCell
        }
        let item = messageHistory.reversed()[indexPath.row]
        inputCell.setupCell(contents: item.text, date: item.date, type: item.situation.rawValue)
        return inputCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let messageHistory = dataManager.messageHistory else{
            return
        }
        let item = messageHistory.reversed()[indexPath.row]
        dismiss(animated: true, completion: {
            self.delegate.situationMenuType = item.situation
            self.delegate.contentsTextView.text = item.text
            self.delegate.contentsTextView.placeHolder = ""
            self.delegate.situationButton.setTitle(item.situation.rawValue, for: .normal)
            self.delegate.titleLabel.text = self.delegate.viewModel.titleLabel[item.situation]
        })
    }
}
