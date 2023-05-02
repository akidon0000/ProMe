//
//  ChatViewController.swift
//  ProMe
//
//  Created by Akihiro Matsuyama on 2023/05/01.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    private let viewModel = ChatViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Protocol： ViewModelが変化したことの通知を受けて画面を更新する
        self.viewModel.checkGPTConnectivity = { [weak self] () in
            guard let self = self else { fatalError() }
            DispatchQueue.main.async {
                self.textView.text = ""
                for message in self.viewModel.messages {
                    if message.role == .user {
                        self.textView.text += "User: " + message.content + "\n"
                    }else{
                        self.textView.text += "System: " + message.content + "\n"
                    }
                }
            }
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        viewModel.askChatGPT(text: textField.text!)
    }
    
    @IBAction func changeButton(_ sender: Any) {

        for message in viewModel.messages {
            if message.role == .user {
                textView.text += "User: " + message.content + "\n"
            }else{
                textView.text += "System: " + message.content + "\n"
            }
        }
        
    }
}
