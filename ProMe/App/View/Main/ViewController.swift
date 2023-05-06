//
//  ViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        // Do any additional setup after loading the view.
//        tableView.estimatedRowHeight = 100
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
     
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.mainTableViewCellContents.count
    }
    
    // セクション内のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mainTableViewCellContents[Int(section)].count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewModel.mainTableViewCellContents[Int(indexPath.section)][Int(indexPath.row)].type {
        case .title: return 44
        case .input: return 100
        case .button: return 50
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.mainTableViewCellContents[Int(indexPath.section)][Int(indexPath.row)]
        switch item.type {
        case .title:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath ) as! TitleTableViewCell
            return titleCell
            
        case .input:
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath ) as! InputTableViewCell
            inputCell.setupCell(title: item.title!)
            return inputCell
            
        case .button:
            let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath ) as! TitleTableViewCell
            return titleCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.mainTableViewCellContents[Int(indexPath.section)][Int(indexPath.row)]
        switch item.type {
        case .title: return
            
        case .input: return
            
        case .button:
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath ) as! InputTableViewCell
            print(inputCell.textView.text)
            
        }
    }
}
