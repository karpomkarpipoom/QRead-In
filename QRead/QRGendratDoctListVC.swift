//
//  QRGendratDoctListVC.swift
//  QRead
//
//  Created by OmniproEdge on 08/11/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import UIKit
import Foundation

class QRGendratDoctListVC: UIViewController {
    
    @IBOutlet weak var GendrateCollectionView: UICollectionView!
    @IBOutlet weak var EmptyStackView: UIStackView!

    let cellIdentifier  = "GenDocCell"
    
    var QRTitle = [String]()
    var QRimage = [UIImage]()
    var QRID    = [String]()
    
    let DBClass = RealmObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.GendrateCollectionView.dataSource   = self
        self.GendrateCollectionView.delegate     = self
    }
    
    func getDownloadData(){
        
        if(RealmCreateObject.count > 0){
            
            self.GendrateCollectionView.alpha = 1
            self.EmptyStackView.alpha = 0
            
            let Directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            for realmDict in RealmCreateObject{
                
                let titleName = realmDict.Title
                QRTitle.append(titleName)

                let IdOfQRCode = realmDict.CreateId
                QRID.append(IdOfQRCode)
               
                let pathURL     = realmDict.createImage
                let imageURL = Directory.appendingPathComponent(pathURL)
                let image    = UIImage(contentsOfFile: imageURL.path) ?? #imageLiteral(resourceName: "404-error")
                    
                // Do whatever you want with the image
                QRimage.append(image)

            }
        }else{
            self.GendrateCollectionView.alpha = 0
            self.EmptyStackView.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
        
        self.ReloadData()
        
    }
    
    func ReloadData(){
        QRTitle.removeAll()
        QRimage.removeAll()
        QRID.removeAll()
        
        getDownloadData()
        
        self.GendrateCollectionView.reloadData()
    }
    
}


extension QRGendratDoctListVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return QRTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! QRGendratCollectionCell
        
        guard QRTitle.count != 0 else { return cell }
        
        cell.ImageCellView.transform = CGAffineTransform(scaleX: CGFloat(1), y: CGFloat(1))
        cell.ImageCellView.image = QRimage[indexPath.item]
        cell.LabelTitle.text = QRTitle[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRDetailViewController") as! QRDetailViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        let predictedVal = self.QRID[indexPath.row]

        // Create the alert controller
        let alertController = UIAlertController(title: "Choose Option", message: "for update a Trip choose any one of the Options.", preferredStyle: .actionSheet)
        /*
        // Create the actions
        let createOwn = UIAlertAction(title: "Share", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
        }
        
        
        let AutoCreate = UIAlertAction(title: "Add/Remove as Faverate", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
        }
        */
        // Create the actions
        let Delete = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
            NSLog("OK Pressed")
            
            self.DBClass.deleteTheGenrateValue(PredicatedValue: predictedVal)
            self.ReloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // for IPAD
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        // Add the actions
        // alertController.addAction(createOwn)
        // alertController.addAction(AutoCreate)
        
        alertController.addAction(Delete)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.GendrateCollectionView.frame.width / 2 - 10, height: self.GendrateCollectionView.frame.width / 2 + 20)
    }
    
}

/*
extension QRGendratDoctListVC {
    
    func FaverButton(indexpath: IndexPath) {
        print("\(indexpath) faver")
        let indexRow = QRID[indexpath.row]
        DBClass.UpdateScanValue(PredicedValue: indexRow, UpdatedValue: true)
    }
    
    
    func OpenWeb(indexpath: IndexPath) {
        print("\(indexpath) OpenWeb")
        if let url = URL(string: QRStrURL[indexpath.row]) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
 
    func CopyToClipBoard(indexpath: IndexPath) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = QRStrURL[indexpath.row]
    }
    
 
    func ShareExtentiions(indexpath: IndexPath) {
        print("\(indexpath) Share")
        
        let firstActivityItem = QRTitle[indexpath.row]
        let secondActivityItem : NSURL = NSURL(string: QRStrURL[indexpath.row])!

        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)

        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]

        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
*/
