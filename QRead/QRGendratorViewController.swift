//
//  QRGendratorViewController.swift
//  QRead
//
//  Created by OmniproEdge on 09/07/18.
//  Copyright © 2018 Erabala. All rights reserved.
//

import UIKit
import Photos

// Create Uniqu ID Values
let uniqueObj = unique()

class QRGendratorViewController: UIViewController {
    
    @IBOutlet weak var QRImageView      : UIImageView!
    @IBOutlet weak var GendrateQRCode   : UIButton!
    @IBOutlet weak var QRTextField      : UITextField!
    
    // UIView
    @IBOutlet weak var TopLayerView: UIView!
    @IBOutlet weak var QrGenImgView: UIView!
    
    let realmObj = RealmObject()
    
    var ImageSaved : Bool = true
    
    var EnterOneTime = false
    var path : URL? = nil
    var snapshot = UIImage()
    
    var qrCodeImage : CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.QRTextField.layer.borderColor = UIColor.black.cgColor
        self.QRTextField.layer.borderWidth = 0.5
        self.QRTextField.attributedPlaceholder = NSAttributedString(string: "QRCode Text",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        QRImageView.isUserInteractionEnabled = true
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(QRGendratorViewController.longPressed(sender:)))
        longPressRecognizer.minimumPressDuration = 1
        
        QRImageView.addGestureRecognizer(longPressRecognizer)
        
        TopLayerView.dropShadow()
        QrGenImgView.dropShadow()
        GendrateQRCode.layer.cornerRadius = 6
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        // Prevent For another action
        if sender.state == .ended {
            self.ImageSaved = true
            return
        }
        
        guard ImageSaved && QRImageView.image != nil else{
            return
        }
        
        let imageData = convert(cmage: qrCodeImage).jpegData(compressionQuality: 1)
        let compressedJPGImage = UIImage(data: imageData!)
        
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        self.ImageSaved = false

        return
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            // we got back an error!
            self.alert(title: "Save error", message: error.localizedDescription)
        } else {
            self.alert(title: "Wow", message: "Your image has been saved Succesfully 🥳..")
        }
    }
    
    func saveimage(){
        
        let image = self.convert(cmage: qrCodeImage)
        
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // choose a name for your image
        let fileName = "\(QRTextField.text!).jpg"
        
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    // MARK:- Gendrate QRCode Action
    @IBAction func GendrateQRCodeAction(_ sender: Any) {
        
        if qrCodeImage == nil{
            
            guard let fieldText = self.QRTextField.text, fieldText.count > 0, fieldText.isAlphanumericWithValideSpecialChar else{
                self.alert(title: "Warning", message: "Some special charecters like (\' \")  Empty text is not allowed to create a QRCode .. ! 🤐")
                return
            }
            
            EnterOneTime = true
            createQRCodeAction()
            
        }else {
            
            self.qrCodeImage        = nil
            self.QRTextField.text   = ""
            self.QRImageView.image  = nil
            
            GendrateQRCode.setTitle("Generate", for: .normal)
        }
        
        QRTextField.isEnabled = !QRTextField.isEnabled
    }
    
    
    func createQRCodeAction(){
        
        let data = QRTextField.text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrCodeImage = filter?.outputImage
        
        // QRTextField.resignFirstResponder()
        
        GendrateQRCode.setTitle("Clear", for: .normal)
        
        DisplayQRCode()
        
        let strBase64 = data?.base64EncodedString(options: .lineLength64Characters)
                
//         let convImage = self.convert(cmage: qrCodeImage)
//         let filePath = saveImageToDocumentDirectory(convImage)
        
        let filePath = saveImageToDocumentDirectory(self.snapshot)
        

        print(uniqueObj.createUniceID())
        
        if EnterOneTime {
            self.realmObj.saveGenerateData(imageData: filePath, title: QRTextField.text!, CreateId: uniqueObj.createUniceID())
            EnterOneTime = false
        }
        
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = uniqueObj.createUniceID().appending(".jpg")
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = chosenImage.jpegData(compressionQuality:  1.0),
          !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)

                return fileName
            } catch {
                return fileURL.absoluteString
            }
        }
        
        return fileName

        /*
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        
        let filename = uniqueObj.createUniceID().appending(".jpg")
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try chosenImage.jpegData(compressionQuality: 1.0)?.write(to: url, options: .atomic)
            print(url)
            return String.init("\(filename)")
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filepath
        }
        */
    }
    
    func convert(cmage : CIImage) -> UIImage {
        let context :   CIContext = CIContext.init(options: nil)
        let cgImage :   CGImage = context.createCGImage(cmage, from: cmage.extent)!
        let image   :   UIImage = UIImage.init(cgImage: cgImage)
        
        return image
    }
    
    // Display QRCode in UIImageView
    func DisplayQRCode() {
        
        let scaleX = QRImageView.frame.size.width / qrCodeImage.extent.size.width
        let scaleY = QRImageView.frame.size.height / qrCodeImage.extent.size.height
        
        let transformaedImage = qrCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        
//        let convImage = self.convert(cmage: transformaedImage)
//        let filePath = saveImageToDocumentDirectory(convImage)
//        print(filePath)
        
        QRImageView.transform = CGAffineTransform(scaleX: CGFloat(1), y: CGFloat(1))
        self.snapshot = UIImage(ciImage: transformaedImage)
        QRImageView.image = UIImage(ciImage: transformaedImage)
        
    }
}

extension QRGendratorViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -150, up: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textfield: textField, moveDistance: -150, up: false)
    }
    
    func moveTextField(textfield: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance: -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
