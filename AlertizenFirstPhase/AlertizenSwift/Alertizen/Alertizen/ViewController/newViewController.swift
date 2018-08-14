//
//  newViewController.swift
//  Alertizen
//
//  Created by Mac OSX on 11/05/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

class newViewController: UIViewController {

    
    @IBOutlet var txtFirst: UITextField!
    @IBOutlet var txtsecond: UITextField!
    @IBOutlet var txtthird: UITextField!
    @IBOutlet var txtfourth: UITextField!
    @IBOutlet var txtfifth: UITextField!
    @IBOutlet var txtsix: UITextField!
    @IBOutlet var txtseven: UITextField!
    @IBOutlet var txteight: UITextField!
    @IBOutlet var txtninth: UITextField!
    @IBOutlet var svMainProfile: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bounds = UIScreen.main.bounds
        
        let height = bounds.size.height
        
        let placeholder = NSAttributedString(string: "Address", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtFirst.attributedPlaceholder = placeholder
        
        let placeholder1 = NSAttributedString(string: "Description of house", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtsecond.attributedPlaceholder = placeholder1
        
        let placeholder2 = NSAttributedString(string: "Doors used by customers", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtthird.attributedPlaceholder = placeholder2
        let placeholder3 = NSAttributedString(string: "Property owner’s name", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtfourth.attributedPlaceholder = placeholder3
        let placeholder4 = NSAttributedString(string: "Busiest time of day", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtfifth.attributedPlaceholder = placeholder4
        let placeholder5 = NSAttributedString(string: "Busiest day of the week", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtsix.attributedPlaceholder = placeholder5
        let placeholder6 = NSAttributedString(string: "Type of narcotics", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtseven.attributedPlaceholder = placeholder6
        
        let placeholder7 = NSAttributedString(string: "Vehicle Description", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txteight.attributedPlaceholder = placeholder7
        
        let placeholder8 = NSAttributedString(string: "License number", attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        txtninth.attributedPlaceholder = placeholder8
        
        switch height
        {
        case 568.0:
            svMainProfile.contentSize = CGSize(width: 0, height: svMainProfile.frame.height-50)
        case 667.0:
            svMainProfile.contentSize = CGSize(width: 0, height: svMainProfile.frame.height)
        case 736.0:
            svMainProfile.contentSize = CGSize(width: 0, height: svMainProfile.frame.height)
        default:
            svMainProfile.contentSize = CGSize(width: 0, height: svMainProfile.frame.height)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK :- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {

        if textField == txtfourth
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else if(textField == txtfifth)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 70), animated: true)
        }
        else if(textField == txtsix)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 80), animated: true)
        }
        else if(textField == txtseven)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 90), animated: true)
        }
        else if(textField == txteight)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
        else if(textField == txtninth)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 140), animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        //svMainProfile.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == txtFirst {
            txtsecond.becomeFirstResponder()
        }
        else if textField == txtsecond {
            txtthird.becomeFirstResponder()
        }
        else if textField == txtthird{
            txtfourth.becomeFirstResponder()
        }
        if textField == txtfourth {
            txtfifth.becomeFirstResponder()
        }
        if textField == txtfifth {
            txtsix.becomeFirstResponder()
        }
        else if textField == txtsix {
            txtseven.becomeFirstResponder()
        }
        else if textField == txtseven{
            txteight.becomeFirstResponder()
        }
        if textField == txteight {
            txtninth.becomeFirstResponder()
        }
        else if textField == txtninth {
            txtninth.resignFirstResponder()
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}
