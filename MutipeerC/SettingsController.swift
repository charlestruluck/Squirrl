//
//  SettingsController.swift
//  MutipeerC
//
//  Created by Charles Truluck on 5/8/17.
//  Copyright © 2017 Charles Truluck. All rights reserved.
//

import UIKit
import MessageUI

class SettingsController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Settings stuff
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                displayShareSheet(shareContent: "We should chat using Squirrl! Download it here: <app store link>")
            case 1:
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            default:
                return
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func displayShareSheet(shareContent: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["feedback@getsquirrl.com"])
        mailComposerVC.setSubject("Squirrl Feedback :) [v" + String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!) + "b" + String(describing: Bundle.main.infoDictionary!["CFBundleVersion"]!) + "]")
        mailComposerVC.setMessageBody("<INSERT FEEDBACK HERE> 👍", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let mailErrorAlert = UIAlertController(title: "Whoops, sorry!", message: "Looks like there was an issue with your mail configuration. Check and make sure you've set up an account in the mail app. Sorry! :(", preferredStyle: .alert)
        mailErrorAlert.addAction(UIAlertAction(title: ":(", style: .default, handler: nil))
        self.present(mailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
