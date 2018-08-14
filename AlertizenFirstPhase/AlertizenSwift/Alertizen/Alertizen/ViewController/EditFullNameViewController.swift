//
//  EditFullNameViewController.swift
//  Alertizen
//
//  Created by MR on 23/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class EditFullNameViewController: UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtFldConfirmPassword: UITextField!
    var titleLabelText:NSString?
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet var lblAgree: UILabel!
    //@IBOutlet var btnCheckMark: UIButton!
    @IBOutlet weak var txtFldFirstName: UITextField!
    @IBOutlet weak var txtFldLastname: UITextField!
    @IBOutlet weak var txtFieldUserName: UITextField!
    @IBOutlet weak var txtFldPasswrd: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    var userDetails_Dict:NSMutableDictionary?
    var temp_Dict: NSMutableDictionary?
    
    var errorStr:String! = nil
    var dictUserInfo: [String : String]! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        userDetails_Dict =  NSMutableDictionary()
        temp_Dict = NSMutableDictionary()
        titleLabel.text = titleLabelText as String?
        
        self.textFieldBorder()
        
        self.HideShowTextFields()
        
        txtFldFirstName.text = fname
        txtFldLastname.text = lname
        //txtFieldUserName.text = username
        txtFldEmail.text = emailKey
    }
   
    func HideShowTextFields()
    {
        if (titleLabelText?.isEqual(to: "Full Name"))!
        {
            txtFldFirstName.isHidden = false
            txtFldLastname.isHidden = false
            txtFieldUserName.isHidden = true
            txtFldPasswrd.isHidden = true
            txtFldEmail.isHidden = true
            txtFldFirstName.becomeFirstResponder()
        }
        else if (titleLabelText?.isEqual(to: "UserName"))!
        {
            txtFieldUserName.isHidden = false
            txtFldFirstName.isHidden = true
            txtFldLastname.isHidden = true
            txtFldPasswrd.isHidden = true
            txtFldEmail.isHidden = true
            txtFieldUserName.becomeFirstResponder()
        }
        else if (titleLabelText?.isEqual(to: "Password"))!
        {
            txtFldPasswrd.isHidden = false
            txtFldConfirmPassword.isHidden = false
            txtFldFirstName.isHidden = true
            txtFldLastname.isHidden = true
            txtFieldUserName.isHidden = true
            txtFldEmail.isHidden = true
            txtFldPasswrd.becomeFirstResponder()
        }
        else if (titleLabelText?.isEqual(to: "Email"))!
        {
            txtFldEmail.isHidden = false
            txtFldFirstName.isHidden = true
            txtFldLastname.isHidden = true
            txtFieldUserName.isHidden = true
            txtFldPasswrd.isHidden = true
            txtFldEmail.becomeFirstResponder()
            //lblAgree.isHidden = false
            //btnCheckMark.isHidden = false
        }
    }
    
    func textFieldBorder()
    {
        let myColor : UIColor = UIColor .lightGray
        txtFldLastname.layer.borderColor = myColor.cgColor
        txtFldLastname.layer.masksToBounds = true
        txtFldLastname.layer.borderWidth = 0.5
        txtFldLastname.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        txtFldFirstName.layer.borderColor = myColor.cgColor
        txtFldFirstName.layer.masksToBounds = true
        txtFldFirstName.layer.borderWidth = 0.5
        txtFldFirstName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        txtFieldUserName.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        txtFldPasswrd.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        txtFldConfirmPassword.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)

        txtFldEmail.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
    }
    
    func updateField() -> Void
    {
     let _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tickBtnClick(_ sender: UIButton)
    {

        if(txtFldFirstName.text != fname)
        {
            updateFirstNm()
        }
        else if(txtFldLastname.text != lname)
        {
            updateLastNm()
        }
//        else if(txtFieldUserName.text != username)
//        {
//            updateUserName()
//        }
        else if(txtFldPasswrd.text != "" && txtFldConfirmPassword.text != "")
        {
            if(txtFldPasswrd.text != txtFldConfirmPassword.text) {
                
                 showAlert(msg: "Sorry, your Passwords were not matching.")
            }
            else {
                
                updatePassword()
            }
        }
        else if(txtFldEmail.text != emailKey)
        {
            updateEmailId()
        }
        else
        {
            showAlert(msg: "Value not changed")
        }
    }
    
    func updateFirstNm()
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        
        self.view.isUserInteractionEnabled = false
        
        let   userDetails_Dict1 =  NSMutableDictionary()
        
        let   temp_Dict1 = NSMutableDictionary()
        
        dictUserInfo = ["data_name":"fname","data_value":txtFldFirstName.text!,"userId":userId] as [String : String]
        
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
        let detail_Dict = detail["userDetails"] as! NSDictionary
        
        temp_Dict1.addEntries(from: detail_Dict as! [AnyHashable : Any])
        
        temp_Dict1.setValue(txtFldFirstName.text, forKey: "fname")
        
        userDetails_Dict1.setValue(temp_Dict1, forKey: "userDetails")
        
        alertizenUser.userData(dic: userDetails_Dict1)
        
        callWebservice()
    }
    
    func updateLastNm()
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        
        self.view.isUserInteractionEnabled = false
        
        userDetails_Dict?.removeAllObjects()
        
        temp_Dict?.removeAllObjects()

        dictUserInfo = ["data_name":"lname","data_value":txtFldLastname.text!,"userId":userId] as [String : String]
        
         let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
         let detail_Dict = detail["userDetails"] as! NSDictionary
         temp_Dict?.addEntries(from: detail_Dict as! [AnyHashable : Any])
    
         temp_Dict?.setValue(txtFldLastname.text, forKey: "lname")
         userDetails_Dict?.setValue(temp_Dict, forKey: "userDetails")
 
        alertizenUser.userData(dic: userDetails_Dict!)
        
        callWebservice()
    }
    
    func updateUserName()
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
       
        self.view.isUserInteractionEnabled = false
        
        userDetails_Dict?.removeAllObjects()
        
        temp_Dict?.removeAllObjects()
        
        dictUserInfo = ["data_name":"username","data_value":txtFieldUserName.text!,"userId":userId] as [String : String]
        
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
        let detail_Dict = detail["userDetails"] as! NSDictionary
        
        temp_Dict?.addEntries(from: detail_Dict as! [AnyHashable : Any])
        
        temp_Dict?.setValue(txtFieldUserName.text, forKey: "username")
        
        userDetails_Dict?.setValue(temp_Dict, forKey: "userDetails")
        
        alertizenUser.userData(dic: userDetails_Dict!)
        
        callWebservice()
        
    }
    
    func updatePassword()
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        
        self.view.isUserInteractionEnabled = false
        
        userDetails_Dict?.removeAllObjects()
        
        temp_Dict?.removeAllObjects()

        dictUserInfo = ["data_name":"password","data_value":txtFldPasswrd.text!,"userId":userId] as [String : String]
        
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
        let detail_Dict = detail["userDetails"] as! NSDictionary
        
        temp_Dict?.addEntries(from: detail_Dict as! [AnyHashable : Any])
        
        temp_Dict?.setValue(txtFldPasswrd.text, forKey: "password")
        
        userDetails_Dict?.setValue(temp_Dict, forKey: "userDetails")
        
        alertizenUser.userData(dic: userDetails_Dict!)
        
        callWebservice()
    }
    
    func updateEmailId()
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        
        self.view.isUserInteractionEnabled = false
        
        userDetails_Dict?.removeAllObjects()
        
        temp_Dict?.removeAllObjects()

        dictUserInfo = ["data_name":"email","data_value":txtFldEmail.text!,"userId":userId,"secure_token":"CMPS-UpProatele"] as [String : String]
        
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
        let detail_Dict = detail["userDetails"] as! NSDictionary
        
        temp_Dict?.addEntries(from: detail_Dict as! [AnyHashable : Any])
        
        temp_Dict?.setValue(txtFldEmail.text, forKey: "email")
        
        userDetails_Dict?.setValue(temp_Dict, forKey: "userDetails")
        
        alertizenUser.userData(dic: userDetails_Dict!)
        
        callWebservice()
    }
    
    func callWebservice()
    {
        WebService.sharedInstance.postMethodWithParams(strURL: "update_profile.php", dict: dictUserInfo as NSDictionary, completionHandler:
            { (dictReponse) in
               
                if (dictReponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                            hud.removeFromSuperview()
                            self.view.isUserInteractionEnabled = true
                            
                            _ =  Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(EditFullNameViewController.moveToPreviousClass), userInfo: nil, repeats: false)
                        }
                }
                else
                {
                    self.errorStr = dictReponse.object(forKey: "error") as! String
                    
                    OperationQueue.main.addOperation
                        {
                            hud.removeFromSuperview()
                            self.view.isUserInteractionEnabled = true
                            self.showAlert(msg:self.errorStr)
                        }
                }
                
        }, failure:{ (errorMsg) in
            
        })
    }

    func moveToPreviousClass()
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: AlertController
    func showAlert(msg:String) -> Void
    {
        let alertController = UIAlertController(title: " ", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
