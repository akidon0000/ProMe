//
//  ViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import UIKit

enum SituationType: String {
    case selfPromote = "自己PR"
    case extracurricularActivities = "ガクチカ"
}

enum AiModelType: String {
    case threePointFiveTurbo = "GPT3.5-turbo"
    case four = "GPT4"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var situationButton: UIButton!
    @IBOutlet weak var aiModelButton: UIButton!
    
    private let dataManager = DataManager.singleton
    private let viewModel = MainViewModel()
    
    private var situationMenuType = SituationType.selfPromote
    private var aiModelMenuType = AiModelType.threePointFiveTurbo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // プルダウンメニュー初期設定
        self.configureSituationMenuButton()
        self.configureAiModelMenuButton()
        
        tableView.register(UINib(nibName: "InputTableViewCell", bundle: nil), forCellReuseIdentifier: "InputTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // 文章作成開始
    @IBAction func startButton(_ sender: Any) {
        let vc = R.storyboard.chat.chatViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func historyButton(_ sender: Any) {
        let vc = R.storyboard.history.historyViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // セクション内のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contentsSelfPromotion[self.situationMenuType]!.count
    }
    
    // セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath ) as! InputTableViewCell
        inputCell.setupCell(title: viewModel.contentsSelfPromotion[self.situationMenuType]![Int(indexPath.row)])
        return inputCell
    }
    
    // タップ無効
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

extension ViewController {
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
        
        tableView.reloadData()
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
