//
//  QRScanDocListVC.swift
//  QRead
//
//  Created by OmniproEdge on 03/11/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import UIKit
class QRScanDocListVC: UIViewController {
    
    @IBOutlet var tableview         : UITableView!
    @IBOutlet weak var EmptyStack   : UIStackView!
    
    // Cell ID
    let cellIdentifier  = "historyCell"
    
    // Array Variables
    var QRStrURL    = [String]()
    var QRID        = [String]()
    var QRTitle     = [String]()
    var QRActualValue = [String]()
    var QRFavour    = [Bool]()
    
    let DBClass = RealmObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.dataSource   = self
        self.tableview.delegate     = self
        self.tableview.tableFooterView = UIView()

        if QRTitle.isEmpty {
            self.alert(title: "oops", message: "No Data Found in History")
        }
        
    }
    
    func getDownloadData(){
        
        if(RealmScanObject.count > 0){
            
            self.EmptyStack.alpha   = 0
            self.tableview.alpha    = 1
            
            for realmDict in RealmScanObject{
                
                let titleName = realmDict.Title
                QRTitle.append(titleName)
                
                let IdOfQRCode = realmDict.ScanId
                QRID.append(IdOfQRCode)
                
                let WebAddress = realmDict.WebURL
                QRStrURL.append(WebAddress)
                
                let isFavour = realmDict.isFavourite
                QRFavour.append(isFavour)
                
                let actualValue = realmDict.ScannedValue
                QRActualValue.append(actualValue)
                
            }
        }else{
            self.EmptyStack.alpha = 1
            self.tableview.alpha = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
        
        self.ReloadTabel()
    }
    
    
    func downloadImage(_ url: URL, imageView: UIImageView){
                
        getDataFromUrl(url) { (data, response, error)  in
            DispatchQueue.main.async(execute: {
                
                guard let data = data , error == nil else { return }
                
                imageView.image = UIImage(data: data)
            })
        }
    }
    
    // helper for loading image
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
        }).resume()
        
    }
    
    func ReloadTabel(){
        
        self.QRID.removeAll()
        self.QRTitle.removeAll()
        self.QRStrURL.removeAll()
        self.QRActualValue.removeAll()
        
        self.getDownloadData()
        
        self.tableview.reloadData()
        
    }
}


extension QRScanDocListVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return QRTitle.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! QRHistoryTableCell
        
        let URLPath = QRStrURL[indexPath.item]
        
        if let url = URL(string: URLPath) {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            url.fetchPageInfo({ (title, description, previewImage) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if let title = title {
                    
                    if title == "Unknown" {
                        cell.tableText.text = self.QRActualValue[indexPath.item]
                    }
                    
                    cell.tableText.text = title
                }
                
                if let description = description {
                    print(description)
                }
                
                if let imageUrl = previewImage {
                    
                    self.downloadImage(URL(string: imageUrl)!, imageView: cell.thumbnailImage)
                    
                    // self.downloadImage(URL(string: imageUrl)!, imageView: self.PreviewImage)
                }
                
            }, failure: { (errorMessage) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                print(errorMessage)
            })
        } else {
            cell.tableText.text = self.QRActualValue[indexPath.item]
        }
        

        cell.Delegate = self
        cell.indepath = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRDetailViewController") as! QRDetailViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let isFavourite = self.QRFavour[editActionsForRowAt.row]
        // let Favourite = isFavourite ? "unloved" : "Favourite"
        
        let more = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.DBClass.deleteTheValue(PredicatedValue: self.QRID[editActionsForRowAt.row])
            self.ReloadTabel()
        }
        more.backgroundColor = .systemRed

        /*
        let favorite = UITableViewRowAction(style: .normal, title: Favourite) { action, index in
            print("favorite button tapped")
            self.DBClass.UpdateScanValue(PredicedValue: self.QRID[editActionsForRowAt.row], UpdatedValue: !isFavourite)
            self.ReloadTabel()
        }
        favorite.backgroundColor = .orange
*/
        return [more]
    }
    
}

extension QRScanDocListVC : QRCellProtocal{
    
    func FaverButton(indexpath: IndexPath) {
        
        let indexRow = QRID[indexpath.row]
        DBClass.UpdateScanValue(PredicedValue: indexRow, UpdatedValue: true)
    }
    
    func OpenWeb(indexpath: IndexPath) {
        
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
