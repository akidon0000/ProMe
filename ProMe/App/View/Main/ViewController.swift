//
//  ViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var situationButton: UIButton!
    @IBOutlet weak var aiModelButton: UIButton!
    
    private let viewModel = MainViewModel()
    
    enum SituationType: String {
        case selfPromote = "自己PR"
        case extracurricularActivities = "学生時代に力を入れたこと"
    }

    enum AiModelType: String {
        case threePointFiveTurbo = "GPT3.5-turbo"
        case four = "GPT4"
    }
    
    var situationMenuType = SituationType.selfPromote
    var aiModelMenuType = AiModelType.threePointFiveTurbo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCell")
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
        self.configureSituationMenuButton()
        self.configureAiModelMenuButton()
        // Do any additional setup after loading the view.
//        tableView.estimatedRowHeight = 100
    }

    private func configureSituationMenuButton() {
        var actions = [UIMenuElement]()
        actions.append(UIAction(title: SituationType.selfPromote.rawValue, image: nil, state: self.situationMenuType == SituationType.selfPromote ? .on : .off,
                                handler: { (_) in
                                    self.situationMenuType = .selfPromote
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureSituationMenuButton()
                                }))
        actions.append(UIAction(title: SituationType.extracurricularActivities.rawValue, image: nil, state: self.situationMenuType == SituationType.extracurricularActivities ? .on : .off,
                                handler: { (_) in
                                    self.situationMenuType = .extracurricularActivities
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureSituationMenuButton()
                                }))

        // UIButtonにUIMenuを設定
        situationButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        // こちらを書かないと表示できない場合があるので注意
        situationButton.showsMenuAsPrimaryAction = true
        // ボタンの表示を変更
        situationButton.setTitle(self.situationMenuType.rawValue, for: .normal)
    }
    
    private func configureAiModelMenuButton() {
        var actions = [UIMenuElement]()
        // HIGH
        actions.append(UIAction(title: AiModelType.threePointFiveTurbo.rawValue, image: nil, state: self.aiModelMenuType == AiModelType.threePointFiveTurbo ? .on : .off,
                                handler: { (_) in
                                    self.aiModelMenuType = .threePointFiveTurbo
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureAiModelMenuButton()
                                }))
        // MID
        actions.append(UIAction(title: AiModelType.four.rawValue, image: nil, state: self.aiModelMenuType == AiModelType.four ? .on : .off,
                                handler: { (_) in
                                    self.aiModelMenuType = .four
                                    // UIActionのstate(チェックマーク)を更新するためにUIMenuを再設定する
                                    self.configureAiModelMenuButton()
                                }))

        // UIButtonにUIMenuを設定
        aiModelButton.menu = UIMenu(title: "", options: .displayInline, children: actions)
        // こちらを書かないと表示できない場合があるので注意
        aiModelButton.showsMenuAsPrimaryAction = true
        // ボタンの表示を変更
        aiModelButton.setTitle(self.aiModelMenuType.rawValue, for: .normal)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
     
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション内のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mainTableViewCellContents.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewModel.mainTableViewCellContents[Int(indexPath.row)].type {
        case .title: return 44
        case .input: return 100
        case .button: return 50
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.mainTableViewCellContents[Int(indexPath.row)]
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
        let item = viewModel.mainTableViewCellContents[Int(indexPath.row)]
        switch item.type {
        case .title: return
            
        case .input: return
            
        case .button:
            let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath ) as! InputTableViewCell
            print(inputCell.textView.text)
            
        }
    }
}
