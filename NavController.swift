//
//  NavController.swift
//  MutipeerC
//
//  Created by Charles Truluck on 5/2/17.
//  Copyright © 2017 Charles Truluck. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
