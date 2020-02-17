//
//  QRHistoryTableCell.swift
//  QRead
//
//  Created by OmniproEdge on 24/10/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import UIKit

protocol QRCellProtocal {
    
    func FaverButton(indexpath : IndexPath)
    func OpenWeb(indexpath : IndexPath)
    func CopyToClipBoard(indexpath : IndexPath)
    func ShareExtentiions(indexpath : IndexPath)
}


class QRHistoryTableCell : UITableViewCell{
    
    var Delegate : QRCellProtocal? = nil
    
    var indepath = IndexPath()

    @IBOutlet weak var webBtnOutlet     : UIButton!
    @IBOutlet weak var copyBtnOutlet    : UIButton!
    @IBOutlet weak var shareBtnOutlet   : UIButton!

    @IBOutlet weak var thumbnailImage   : UIImageView!
    @IBOutlet weak var tableText        : UILabel!
    
    @IBAction func OpenWeb(_ sender: Any) {
        self.Delegate?.OpenWeb(indexpath: indepath)
    }
    
    @IBAction func CopyToClipBoard(_ sender: Any) {
        self.Delegate?.CopyToClipBoard(indexpath: indepath)
    }
    
    @IBAction func ShareExtentiions(_ sender: Any) {
        self.Delegate?.ShareExtentiions(indexpath: indepath)
    }
    
    override func awakeFromNib() {

        webBtnOutlet.layer.cornerRadius   = 6
        copyBtnOutlet.layer.cornerRadius  = 6
        shareBtnOutlet.layer.cornerRadius = 6

        tableText.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
}
