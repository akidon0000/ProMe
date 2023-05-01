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
        
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        viewModel.askChatGPT(text: textField.text!)
    }
    @IBAction func changeButton(_ sender: Any) {
        textView.text = viewModel.messages.description
    }
}
