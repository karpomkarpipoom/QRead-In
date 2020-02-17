//
//  QRExtention+Alert.swift
//  QRead
//
//  Created by Bala on 28/01/17.
//  Copyright © 2017 Erabala. All rights reserved.
//

import UIKit

//  class     - Call by reference
//  struct    - Call by value
//  extension - Customize the UIButton / what ever subclass


extension UIButton{
    
    func shakeAnime() {
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPoint(x:self.center.x - 5,y: self.center.y)
        let from_value:NSValue = NSValue(cgPoint: from_point)
        
        let to_point:CGPoint = CGPoint(x:self.center.x + 5,y: self.center.y)
        let to_value:NSValue = NSValue(cgPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        self.layer.add(shake, forKey: "position")
    }
    
    func shakeAction() { print("Shake") }
}


// MARK:- Extention for UIViewController
extension UIViewController {
        
    func alert( title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func copyToClipBoard(URLorString : String) {
        UIPasteboard.general.string = URLorString as String
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK:- Extention for UIView
extension UIView {
    
    func dropShadow(scale: Bool = true) {
        
        layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.cornerRadius = 5
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension String {
    
    var isAlphanumericWithValideSpecialChar : Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9://._=?%+ -]", options: .regularExpression) == nil
    }
    
}

extension UIColor {
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
}
