//
//  ViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import UIKit

enum SituationType: String, Codable {
    case selfPromote = "自己PR"
    case extracurricularActivities = "ガクチカ"
}

enum AiModelType: String {
    case threePointFiveTurbo = "GPT3.5-turbo"
    case four = "GPT4"
}

final class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var situationButton: UIButton!
    @IBOutlet weak var aiModelButton: UIButton!
    
    public var messages:[String]?
    
    public var situationMenuType = SituationType.selfPromote
    
    private let viewModel = MainViewModel()
    
    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton
    
    private var aiModelMenuType = AiModelType.threePointFiveTurbo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupDelegate()
    }
    
    // 文章作成開始
    @IBAction func startButton(_ sender: Any) {
        var lists:[String] = []
        for i in 0..<dataManager.textGenerationUserInfo.count {
            
            lists.append(dataManager.textGenerationUserInfo.value(at: i) ?? "xx")
        }
        
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setTemplate(.full)
        print(dateFormatter.string(from: dt))
        
        let saveMessage = DataManager.SaveMessage(situationType: self.situationMenuType,
                                                  messages: lists,
                                                  date: dateFormatter.string(from: dt))
        if dataManager.saveMessages == nil {
            dataManager.saveMessages = [saveMessage]
        }else{
            dataManager.saveMessages!.append(saveMessage)
        }
        let vc = R.storyboard.chat.chatViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func historyButton(_ sender: Any) {
        let vc = R.storyboard.history.historyViewController()!
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    private func setupDefaults() {
        configureSituationMenuButton()
        configureAiModelMenuButton()
        tableView.register(R.nib.inputTableViewCell)
    }
    
    private func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contentsSelfPromotion[self.situationMenuType]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCell = tableView.dequeueReusableCell(withIdentifier: "InputTableViewCell", for: indexPath ) as! InputTableViewCell
//        guard let message = messages?[Int(indexPath.row)] else{
//            return
//        }
//        let txt = messages!
        inputCell.setupCell(title: viewModel.contentsSelfPromotion[self.situationMenuType]![Int(indexPath.row)],
                            contents: messages?[Int(indexPath.row)] ?? "")
        return inputCell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // タップ無効
        return nil
    }
}
