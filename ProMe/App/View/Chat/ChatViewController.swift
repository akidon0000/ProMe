//
//  ChatViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    private let dataManager = DataManager.singleton
    
    private let viewModel = ChatViewModel()
    
    private var isFirstLayout: Bool = true
    
    var navigationBarView: UIView!
    
    var backButton: UIButton!
    
    var messageList: [MockMessage] = [] {
        didSet {
            // messagesCollectionViewをリロード
            self.messagesCollectionView.reloadData()
            // 一番下までスクロールする
            self.messagesCollectionView.scrollToLastItem()
        }
    }

    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
        setupDelegates()
        setupInput()
        setupButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func onClickMyButton(sender: UIButton) {
        dismiss(animated: true)
    }
    
    // MARK: - Methods [Private]
    
    private func setupDefaults() {
        // 背景の色を指定
        messagesCollectionView.backgroundColor = .systemGray6

        // メッセージ入力時に一番下までスクロール
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.checkGPTConnectivity = { [weak self] () in
            guard let self = self else { fatalError() }
            DispatchQueue.main.async {
                // モックデータを取得
                self.messageList = MockMessage.getMessages()
            }
        }
        
        guard let fileURL = Bundle.main.url(forResource: "prompt-self-promotion", withExtension: "txt"),
              let fileContents = try? String(contentsOf: fileURL, encoding: .utf8) else {
                  fatalError("読み込み出来ません")
              }
//        let prompt = fileContents + dataManager.messageHistory[dataManager.messageHistory?.count-1]
//        dataManager.chatMessages.append(MockMessage.createMessage(text: fileContents, user: .me))
//        viewModel.askChatGPT(text: prompt)
    }
    
    private func setupDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
    }
    
    private func setupSubView() {
        // Hack to prevent animation of the contentInset after viewDidAppear
        if isFirstLayout {
            defer { isFirstLayout = false }
            // Viewを生成.
            navigationBarView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.safeAreaInsets.top + 44))
            navigationBarView.backgroundColor = UIColor.green
            
            // ボタンを生成.
            backButton = UIButton(frame: CGRect(x: 5, y: self.view.safeAreaInsets.top+2, width: 60, height:40))
            backButton.backgroundColor = UIColor.systemGray5
            backButton.layer.cornerRadius = 20.0
//            backButton.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
            backButton.setTitle("戻る", for: .normal)
            backButton.setTitleColor(UIColor.black, for: .normal)
            backButton.addTarget(self, action: #selector(ChatViewController.onClickMyButton(sender:)), for: .touchUpInside)
            
//            addKeyboardObservers()
//            messageCollectionViewBottomInset = requiredInitialScrollViewBottomInset()
        }

//        navigationBarView.isHidden = true
        
//        // ボタンを生成.
//        backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        backButton.backgroundColor = UIColor.red
//        backButton.layer.cornerRadius = 20.0
//        backButton.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height-50)
//        backButton.setTitle("Appear", for: .normal)
//        backButton.setTitleColor(UIColor.white, for: .normal)
//        myButton.addTarget(self, action: #selector(ViewController.onClickMyButton(sender:)), for: .touchUpInside)
        
        // myViewをviewに追加.
        self.view.addSubview(navigationBarView)
        
        // ボタンをviewに追加.
        self.view.addSubview(backButton)
    }
    
    private func setupInput() {
        // プレースホルダーの指定
        messageInputBar.inputTextView.placeholder = "Aa"
        // 入力欄のカーソルの色を指定
        messageInputBar.inputTextView.tintColor = .blue
        // 入力欄の色を指定
        messageInputBar.inputTextView.backgroundColor = .systemGray6
        messageInputBar.inputTextView.cornerRound = 15.0
    }
    
    private func setupButton() {
        // ボタンの変更
        messageInputBar.sendButton.title = "送信"
        // 送信ボタンの色を指定
        messageInputBar.sendButton.tintColor = .lightGray
    }
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return userType.me.data
    }
    
    func otherSender() -> SenderType {
        return userType.you.data
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }

    // メッセージの上に文字を表示
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 10),
                    .foregroundColor: UIColor.darkGray
                ]
            )
        }
        return nil
    }

    // メッセージの上に文字を表示（名前）
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {

    // メッセージの色を変更
    func textColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .white : .white
    }

    // メッセージの背景色を変更している
    func backgroundColor(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .green : .white
    }

    // メッセージの枠にしっぽを付ける
    func messageStyle(
        for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .topRight : .topLeft
        return .bubbleTail(corner, .curved)
    }

    // アイコンをセット
    func configureAvatarView(
        _ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
    ) {
        avatarView.set( avatar: Avatar(initials: message.sender.senderId == "001" ? "😊" : "🥳") )
    }
}

// 各ラベルの高さを設定（デフォルト0なので必須）
// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        indexPath.section % 3 == 0 ? 10 : 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        16
    }
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {

    // Cellのバックグラウンドをタップした時の処理
    func didTapBackground(in cell: MessageCollectionViewCell) {
        print("バックグラウンドタップ")
        closeKeyboard()
    }

    // メッセージをタップした時の処理
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("メッセージタップ")
        closeKeyboard()
    }

    // アバターをタップした時の処理
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("アバタータップ")
        closeKeyboard()
    }

    // メッセージ上部をタップした時の処理
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("メッセージ上部タップ")
        closeKeyboard()
    }

    // メッセージ下部をタップした時の処理
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("メッセージ下部タップ")
        closeKeyboard()
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    // 送信ボタンをタップした時の挙動
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let attributedText = NSAttributedString(
            string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.white])
        let message = MockMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
        self.messageList.append(message)

        self.messageInputBar.inputTextView.text = String()
        self.messageInputBar.invalidatePlugins()
        self.messagesCollectionView.scrollToLastItem()
        
        viewModel.askChatGPT(text: attributedText.string)
    }

}

extension ChatViewController {
    func closeKeyboard(){
        self.messageInputBar.inputTextView.resignFirstResponder()
        self.messagesCollectionView.scrollToLastItem()
    }
}
