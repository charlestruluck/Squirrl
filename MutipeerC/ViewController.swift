//
//  ViewController.swift
//  MutipeerC
//
//  Created by Charles Truluck on 5/1/17.
//  Copyright © 2017 Charles Truluck. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate {
    
    let messageService = MessageService()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var sendInput: UITextField!
    
    var messagesHeight: CGFloat = 10.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            show(SetupViewController(), sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageService.delegate = self
        sendInput.delegate = self
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigation.title = "0 users"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        setupMessage()
        return false
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        setupMessage()
    }
    
    func setupMessage() {
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        var minute = String(describing: minutes)
        if minutes < 10 {
            minute = String(format: "%02d", minutes)
        } else {
            minute = String(describing: minutes)
        }
        if hour > 12 {
            hour = hour - 12
            minute = minute + " PM"
        } else {
            minute = minute + " AM"
        }
        let info = MessageInfo(sender: "\(UIDevice.current.name)", message: sendInput.text!, time: "- \(hour):\(minute)", color: Color.gray)
        messageService.send(info: info)
        info.changeColor(color: Color.blue)
        self.addMessage(info: info)
        self.view.endEditing(true)
        sendInput.text = ""
    }
    
    func addMessage(info: MessageInfo) {
        let containerBox = UIView(frame: CGRect(x: 0, y: Int(messagesHeight), width: Int(scrollView.frame.width), height: 0))
        let messageBox = InsetLabel(frame: CGRect(x: 0, y: Int(messagesHeight), width: Int(scrollView.frame.width), height: 0))
        let senderLabel = InsetLabel(frame: CGRect(x: 0, y: Int(messagesHeight - 14), width: Int(scrollView.frame.width), height: 12))
        if info.message == "" {
            return
        }
        senderLabel.font = UIFont.systemFont(ofSize: 12)
        senderLabel.text = "\(info.sender) \(info.time)"
        senderLabel.sizeToFit()
        senderLabel.frame = CGRect(x: senderLabel.frame.origin.x, y: senderLabel.frame.origin.y, width: scrollView.frame.width, height: senderLabel.frame.height)
        messageBox.numberOfLines = 0
        messageBox.text = (info.message)
        messageBox.sizeToFit()
        messageBox.frame = CGRect(x: messageBox.frame.origin.x, y: messageBox.frame.origin.y + 3, width: scrollView.frame.width, height: messageBox.frame.height + 10)
        messageBox.backgroundColor = info.color
        if info.color == Color.blue {
            messageBox.textColor = .white
            messageBox.textAlignment = .left
            senderLabel.textAlignment = .right
            print(senderLabel.frame.maxX)
            if messageBox.frame.height <= 32.0 {
                let previousHeight = messageBox.frame.height
                messageBox.sizeToFit()
                messageBox.frame = CGRect(x: (scrollView.frame.width - messageBox.frame.width) - 24, y: messageBox.frame.origin.y, width: messageBox.frame.width + 20, height: previousHeight)
            }
            print(messageBox.frame.height)
        } else {
            if messageBox.frame.height <= 32.0 {
                let previousHeight = messageBox.frame.height
                messageBox.sizeToFit()
                messageBox.frame = CGRect(x: messageBox.frame.origin.x, y: messageBox.frame.origin.y, width: messageBox.frame.width + 20, height: previousHeight)
            }
        }
        messageBox.layer.cornerRadius = 10
        messageBox.clipsToBounds = true
        containerBox.sizeToFit()
        containerBox.addSubview(senderLabel)
        containerBox.addSubview(messageBox)
        scrollView.addSubview(containerBox)
        messagesHeight += messageBox.frame.height + senderLabel.frame.height - 17
        scrollView.contentSize.height = messagesHeight * 2
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height), animated: false)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
//    @IBAction func feedbackPressed(_ sender: Any) {
//        self.show(SettingsController(), sender: self)
//    }
    
}

class InsetLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)))
    }
}

extension ViewController: MessageServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: MessageService, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.navigation.title = "\(connectedDevices.count) users"
        }
    }
    
    func messageAdded(manager: MessageService, info: MessageInfo) {
        OperationQueue.main.addOperation {
            self.addMessage(info: info)
        }
    }
    
}
