//
//  QRMoreViewController.swift
//  QRead
//
//  Created by OmniproEdge on 18/08/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import UIKit
import MessageUI

class QRMoreViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var YtLinkBtn        : UIButton!
    @IBOutlet weak var GetinTouchView   : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YtLinkBtn.layer.cornerRadius = 6
        GetinTouchView.layer.cornerRadius = 6
    }
    
    @IBAction func OpenYoutube(_ sender: Any) {
        
        let youtubeId = "karpomkarpipoom"
        let url = URL(string:"http://www.youtube.com/\(youtubeId)")!
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        
    }
    
    @IBAction func ContactusBtn(_ sender: Any) {
        
        let mailComposeViewController = configureMailComposer()
           if MFMailComposeViewController.canSendMail(){
               self.present(mailComposeViewController, animated: true, completion: nil)
           }else{
               print("Can't send email")
            self.alert(title: "Sorry 😒", message: "Email Configure is Missing")
           }
    }
    
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["karpomkarpipoom@gmail.com"])
        mailComposeVC.setSubject("QRead App : Need Your Support")
        mailComposeVC.setMessageBody("<p>Hey Hi Karpom Karpipoom</p>", isHTML: true)
        return mailComposeVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
