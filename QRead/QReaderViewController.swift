//
//  QReaderViewController.swift
//  QRead
//
//  Created by Bala-MAC on 1/28/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

import UIKit
import AVFoundation
import SafariServices

class QReaderViewController: UIViewController {
    
    @IBOutlet var QRCamLabel    : UILabel!
    @IBOutlet var QRCam         : UIView!
    @IBOutlet var QRFlash       : UIButton!
    @IBOutlet weak var CameraTargetCircul: UIButton!
    
    var captureSession      : AVCaptureSession!
    
    var videoPreviewLayer   : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView     : UIView?
    
    // 3
    var QRStrURL    = [String]()
    var QRTitle     = [String]()
    
    let realmObj = RealmObject()
    
    let device = AVCaptureDevice.default(for: AVMediaType.video)
    
    // TYPES OF FEATCHING CODES
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            /*
             // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
             let captureMetadataOutput = AVCaptureMetadataOutput()
             captureSession?.addOutput(captureMetadataOutput)
             
             // Set delegate and use the default dispatch queue to execute the call back
             captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
             captureMetadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
             
             */
            let metadataOutput = AVCaptureMetadataOutput()
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = supportedCodeTypes
            } else {
                failed()
                return
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubviewToFront(QRCamLabel)
        view.bringSubviewToFront(QRCam)
        view.bringSubviewToFront(QRFlash)
        view.bringSubviewToFront(CameraTargetCircul)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
            QRFlashBtn(self)
        }
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func getDownloadData(){
        
        self.QRStrURL.removeAll()
        self.QRTitle.removeAll()
        
        if(RealmScanObject.count > 0){
            
            for realmDict in RealmScanObject{
                
                let titleName = realmDict.Title
                QRTitle.append(titleName)
                
                let WebAddress = realmDict.ScannedValue
                QRStrURL.append(WebAddress)
                
            }
        }
    }
    
    func normalString( QRString : String) {
        // Handling in Alert
        let alertMsg = "Do you want to open this " + QRString  // Check with the type...
        let alert = UIAlertController(title: "Alert", message: alertMsg as String , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Copy",
                                      style: UIAlertAction.Style.default,
                                      handler: {(alert: UIAlertAction!) in
                                        
                                        self.copyToClipBoard(URLorString: QRString)
        }))
        
        if TextType(type: QRString as String) == "Web Address" {
            
            alert.addAction(UIAlertAction(title: "Web",
                                          style: UIAlertAction.Style.default,
                                          handler: {(alert: UIAlertAction!) in
                                            self.openInWebView(WebURL: QRString)
            }))
            
        }
        
        alert.addAction(UIAlertAction(title: "Share",
                                      style: UIAlertAction.Style.default,
                                      handler: {(alert: UIAlertAction!) in
                                        self.displayShareSheet(shareContent: QRString as String)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        self.alert(title: "Alert", message: QRString as String)
        
    }
    
    func TextType(type: String) -> String {
        
        if type.contains("mail"){
            return "Mail"
        }else if type.contains("number"){
            return "Mobile number"
        }else if type.contains("http:"){
            return "Web Address"
        }else if type.contains("https:"){
            return "Web Address"
        }else{
            return "String"
        }
    }
    
    func openInWebView(WebURL : String) {
        
        if let url = URL(string: WebURL as String) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    
    func displayShareSheet(shareContent:String) {
        
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    
    @IBAction func QRFlashBtn(_ sender: Any) {
        
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureDevice.TorchMode.on) {
                    QRFlash.setImage(#imageLiteral(resourceName: "Flash-On"), for: .normal)
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                } else {
                    do {
                        QRFlash.setImage(#imageLiteral(resourceName: "Flash-Off"), for: .normal)
                        try device?.setTorchModeOn(level: 1.0)
                    } catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
                // QRFlash.setImage(#imageLiteral(resourceName: "Flash-On"), for: .normal)
                
            } catch {
                print(error)
            }
        }
    }
    
}


extension QReaderViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func QRMetadataValue (QRString : String) {
        
        let types : NSTextCheckingResult.CheckingType = .link
        var URLStrings  = [NSURL]()
        let detector    = try? NSDataDetector(types: types.rawValue)
        
        detector?.enumerateMatches(in: QRString as String, options: [], range: NSMakeRange(0, (QRString as NSString).length)) { (result, flags, _) in
                        
            URLStrings.append(result!.url! as NSURL)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // Show Normal Aleart
            self.normalString(QRString: QRString)
        }
        
        self.getDownloadData()
        
        if QRStrURL.contains(QRString as String){
            return
        }
        
        let currentDateTime = Date()
        
        var WebSiteURL : String = ""
        
        if TextType(type: QRString as String) == "Web Address" {
            WebSiteURL = QRString as String
        }
        
        self.realmObj.saveScanData( webURL: WebSiteURL as String, title: "unknown", actualData: QRString as String, timeDate: "\(currentDateTime)", description: "", scanId: uniqueObj.createUniceID(), type: TextType(type: QRString as String))
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            QRCamLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                launchApp(decodedURL: metadataObj.stringValue!)
                QRCamLabel.text = metadataObj.stringValue
                QRMetadataValue(QRString: metadataObj.stringValue!)
            }
        }
    }
    
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You Need to Check \"\(decodedURL)\" ?", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
}
