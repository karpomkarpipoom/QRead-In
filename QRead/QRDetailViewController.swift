//
//  QRDetailViewController.swift
//  QRead
//
//  Created by Bala-MAC on 2/2/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

import UIKit

class QRDetailViewController: UIViewController {
    @IBOutlet var OpenWeb: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title? = "hi"
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func OpenWebAction(_ sender: UIButton) {
        sender.shakeAnime()
    }

}
