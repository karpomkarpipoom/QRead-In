//
//  QRHistoryTableView.swift
//  QRead
//
//  Created by Bala-MAC on 2/1/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

import UIKit
import RealmSwift
import TwicketSegmentedControl

let RealmCreateObject = realm.objects(createObject.self)

class QRHistoryTableView: UIViewController {

    @IBOutlet weak var SgmentView   : TwicketSegmentedControl!
    
    @IBOutlet weak var ScanValuesView: UIView!
    @IBOutlet weak var createQRView: UIView!
    
    let segmentTitles   = ["History", "Gendrator"]
    
    let PreviewImage : UIImageView? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SgmentView.delegate         = self
        SgmentView.defaultTextColor = UIColor.white
        SgmentView.sliderBackgroundColor    =  #colorLiteral(red: 1, green: 0.2310000062, blue: 0.1879999936, alpha: 1)
        
        /// UIColor.init(hexString: "#FF6161", alpha: 100)
        
        SgmentView.segmentsBackgroundColor  = .darkGray
        SgmentView.setSegmentItems(segmentTitles)

        self.ScanValuesView.alpha   = 1
        self.createQRView.alpha     = 0
    }
    
}


extension QRHistoryTableView: TwicketSegmentedControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        
        switch segmentIndex {
        case 0:
            
            UIView.animate(withDuration: 0.5, animations: {
                self.ScanValuesView.alpha = 1
                self.createQRView.alpha = 0
            })
            
        default:
            
            UIView.animate(withDuration: 0.5, animations: {
                self.ScanValuesView.alpha = 0
                self.createQRView.alpha = 1
            })
            
        }
        
    }
    
}
