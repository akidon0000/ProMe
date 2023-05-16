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
    
    @IBOutlet weak var situationButton: UIButton!
    @IBOutlet weak var aiModelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: PlaceTextView!
    
    public var messages:[String]?
    
    public var situationMenuType = SituationType.selfPromote
    
    public let viewModel = MainViewModel()
    
    // 共通データ・マネージャ
    private let dataManager = DataManager.singleton
    
    private var aiModelMenuType = AiModelType.threePointFiveTurbo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    // 文章作成開始
    @IBAction func startButton(_ sender: Any) {
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.setTemplate(.full)
        
        let list = DataManager.MessageData(situation: self.situationMenuType,
                                                             text: contentsTextView.text,
                                                             date: dateFormatter.string(from: dt))
        if let messageHistory = dataManager.messageHistory {
            dataManager.messageHistory = messageHistory + [list]
        }else{
            dataManager.messageHistory = [list]
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
        titleLabel.text = viewModel.titleLabel[self.situationMenuType]
        contentsTextView.placeHolder = viewModel.placeHolderContents[self.situationMenuType]!
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
        
        titleLabel.text = viewModel.titleLabel[self.situationMenuType]
        contentsTextView.placeHolder = viewModel.placeHolderContents[self.situationMenuType]!
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
