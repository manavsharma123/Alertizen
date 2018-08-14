//
//  CreateProfileVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
class CreateProfileVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtEmailAddress: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var svMainProfile: UIScrollView!

    var successStr:String! = nil
    var phoneStr:String! = nil
    var errorStr:String! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Tap Gesture
    func handleTap() -> Void
    {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtUserName.resignFirstResponder()
        txtEmailAddress.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }

    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
       let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK :- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if((textField.text?.isEqual("First Name"))!||(textField.text?.isEqual("Last Name"))!||(textField.text?.isEqual("UserName"))!||(textField.text?.isEqual("Email Address"))!)
        {
            textField.text = ""
        }
        else if(textField.text? .isEqual("Password"))!
        {
            txtPassword.text = ""
            txtPassword.isSecureTextEntry = true
        }
        svMainProfile.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(txtFirstName.text?.isEqual(""))!
        {
            txtFirstName.text = "First Name"
        }
        else if(txtLastName.text?.isEqual(""))!
        {
            txtLastName.text = "Last Name"
        }
        else if(txtUserName.text?.isEqual(""))!
        {
            txtUserName.text = "UserName"
        }
        else if(txtEmailAddress.text?.isEqual(""))!
        {
            txtEmailAddress.text = "Email Address"
        }
        else if(txtPassword.text?.isEqual(""))!
        {
            txtPassword.text = "Password"
            txtPassword.isSecureTextEntry = false
        }
        svMainProfile.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName {
            txtUserName.becomeFirstResponder()
        }
        else if textField == txtUserName{
            txtEmailAddress.becomeFirstResponder()
        }
        
        if textField == txtEmailAddress {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func btnNextClick(_ sender: AnyObject)
    {
        txtFirstName.resignFirstResponder()
        txtLastName.resignFirstResponder()
        txtUserName.resignFirstResponder()
        txtEmailAddress.resignFirstResponder()
        txtPassword.resignFirstResponder()
        
        if(txtFirstName.text != "First Name") || (txtLastName.text != "Last Name") || (txtUserName.text != "UserName") || (txtEmailAddress.text != "Email Address") || (txtPassword.text != "Password")
        {
            SVProgressHUD.show(withStatus:"")
            let dictUserInfo = ["phone":phoneStr,"first_name":txtFirstName.text!,"last_name":txtLastName.text!,"username":txtUserName.text!,"email":txtEmailAddress.text!,"password":txtPassword.text!,"filename":"photo.jpg","binary_file":""] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "signup.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                        {
                        
                            self.successStr = dictReponse.object(forKey: "success") as! String!
                            SVProgressHUD.dismiss()
                            
                            self.moveToNextClass()
                        }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        
                        OperationQueue.main.addOperation
                        {
                               SVProgressHUD.dismiss()
                                self.showAlert(msg:self.errorStr)
                        }
                    }
            }, failure:{ (errorMsg) in
                print(errorMsg)
            })
        }
        else
        {
            self.showAlert(msg:"Please fill the data.")
        }
    }
    
    func moveToNextClass()
    {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "accept") as! AcceptNotificationsVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK: AlertController
    func showAlert(msg:String) -> Void
    {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func btnFBSignUpClick(_ sender: Any)
    {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.systemAccount
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], handler:
            { (result, error) -> Void in
                if (error == nil)
                {
                    
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    
                    if(fbloginresult.grantedPermissions != nil)
                    {
                        if(fbloginresult.grantedPermissions.contains("email"))
                        {
                            self.getFBUserData()
                        }
                    }
                }
        })
    }
    func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler: { (connection, result, error) -> Void in
                var dict = NSDictionary()
                dict = result as! NSDictionary
                if (error == nil)
                {
                    
                    print("userInfo is \(result))")
                    let dictUserInfo = ["userid":uuid,"username":dict.value(forKey: "name") as!String,"email":dict.value(forKey: "email") as!String,"first_name":dict.value(forKey: "first_name") as!String,"last_name":dict.value(forKey: "last_name") as!String,"phone":"","filename":"photo.jpg","binary_file":""] as [String : String]
                    
                    WebService.sharedInstance.postMethodWithParams(strURL: "fb_login.php", dict: dictUserInfo as NSDictionary, completionHandler:
                        {(dictReponse) in
                            print(dictReponse)
                            
                            if (dictReponse.object(forKey: "success") != nil)
                            {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "campus") as! CampusSelectionVC
                                self.navigationController?.pushViewController(obj, animated: true)
                                
                            }
                    } ,failure:{ (errorMsg) in
                        print(errorMsg)
                    })
                                    }
            })
        }
    }

}
