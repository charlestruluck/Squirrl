//
//  MessageInfo.swift
//  MutipeerC
//
//  Created by Charles Truluck on 5/1/17.
//  Copyright © 2017 Charles Truluck. All rights reserved.
//

import Foundation
import UIKit

class MessageInfo: NSObject, NSCoding {
    
    let sender: String
    let message: String
    let time: String
    var color: UIColor
    
    init(sender: String, message: String, time: String, color: UIColor) {
        self.sender = sender
        self.message = message
        self.time = time
        self.color = color
    }
    
    required init(coder decoder: NSCoder) {
        self.sender = decoder.decodeObject(forKey: "sender") as? String ?? ""
        self.message = decoder.decodeObject(forKey: "message") as? String ?? ""
        self.time = decoder.decodeObject(forKey: "time") as? String ?? ""
        self.color = decoder.decodeObject(forKey: "color") as? UIColor ?? Color.gray
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(sender, forKey: "sender")
        coder.encode(message, forKey: "message")
        coder.encode(time, forKey: "time")
        coder.encode(color, forKey: "color")
    }
    
    func changeColor(color: UIColor) {
        self.color = color
    }
}
