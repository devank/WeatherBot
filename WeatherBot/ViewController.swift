//
//  ViewController.swift
//  WeatherBot
//
//  Created by Devan on 09/04/18.
//  Copyright © 2018 Devan K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var textInputView: UIView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var typingIndicator: UILabel!
    var data : [MessageModel] = []
    var lastMessage: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.typingIndicator.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 75
        self.tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        messageTextBox.addTarget(self, action: #selector(self.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.typingIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)){
            self.typingIndicator.isHidden = true
            self.data.append(self.createMessage(messageText: ChatManager.sayHello(), user: .receiver))
            self.tableView.reloadData()
        }
    }
    func createMessage(messageText: String, user: User) -> MessageModel {
        let message = MessageModel()
        message.message = messageText
        message.user = user
        return message
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func resignFirstResponder() -> Bool {
        self.sendMessageToBot()
        return true
    }

    @IBAction func didSelectSend(_ sender: UIButton) {
        self.sendMessageToBot()
    }
    
    func sendMessageToBot() {
        if messageTextBox.text != "" {
            self.lastMessage = messageTextBox.text!
            messageTextBox.text = ""
            let message = MessageModel()
            message.user = .sender
            message.message = self.lastMessage
            data.append(message)
            self.tableView.reloadData()
            self.scrollToBottom()
            self.displayBotResponse()
        }
    }
    
    func displayBotResponse() {
        self.typingIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)){
            ChatManager.getResponse(inputString: self.lastMessage, completion: {
                (response) in
                DispatchQueue.main.async {
                    self.typingIndicator.isHidden = true
                    let message = self.createMessage(messageText: response, user: .receiver)
                    self.data.append(message)
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            })
        }
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        let keyboardAnimationDetails = notification.userInfo!
        let duration = keyboardAnimationDetails[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        var keyboardFrame = (keyboardAnimationDetails[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if let window = self.view.window {
            keyboardFrame = window.convert(keyboardFrame, to: self.view)
        }
        let animationCurve = keyboardAnimationDetails[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        self.tableView.isScrollEnabled = false
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast
        self.view.layoutIfNeeded()
        var chatInputOffset = -((self.view.bounds.height-self.bottomLayoutGuide.length)-keyboardFrame.minY)
        if chatInputOffset > 0 {
            chatInputOffset = 0
        }
        self.keyboardHeightLayoutConstraint.constant = chatInputOffset
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: animationCurve), animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        })  { (finished) in
                self.tableView.isScrollEnabled = true
                self.tableView.decelerationRate = UIScrollViewDecelerationRateNormal
        }
    }
    func scrollToBottom() {
        if data.count > 0 {
            let indexPath = IndexPath(row: data.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = data[indexPath.row]
        if message.user! == .sender {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderMessageCell
            cell.senderMessageLabel.text = message.message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverMessageCell
            cell.receiverMessageLabel.text = message.message
            return cell
        }
    }
}

