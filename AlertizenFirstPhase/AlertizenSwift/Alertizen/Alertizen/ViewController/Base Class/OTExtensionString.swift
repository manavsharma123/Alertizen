//
//  OTExtensionString.swift
//  Raj
//
//  Created by Raj on 10/11/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func Trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isValidEmail() -> Bool {
        
        let stricterFilter: Bool = true
        
        let stricterFilterString: String = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        
        let laxString: String = ".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*"
        
        let emailRegex: String = stricterFilter ? stricterFilterString : laxString
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: self)
    }
    
}
extension UIAlertController
{
    class func Alert(title: String, msg: String, vc: UIViewController) -> Void
    {
        let myAlertVC = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
            hud.removeFromSuperview()
        }
        
        myAlertVC.addAction(okAction)
        
        vc.present(myAlertVC, animated: true, completion: nil)
    }
}


extension UITextField {
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        
        doneToolbar.items = items
        
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        
        self.resignFirstResponder()
    }
}
