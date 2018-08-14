//
//  UserSignInVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import AirshipKit

class UserSignInVC: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {

    @IBOutlet weak var forgotPwd:UIButton!
    
    @IBOutlet weak var btnAlreadyHaveAccount:UIButton!
    
    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var username:UITextField!
    
    @IBOutlet weak var pasword:UITextField!
    
    var errorStr:String! = nil

    var attrs = [
        NSForegroundColorAttributeName : UIColor.black,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
        ] as [String : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    var attributedString1 = NSMutableAttributedString(string:"")
    
    var successStr:String! = nil
    
    var isRegisteredForLocalNotifications : Bool!
    
//    var errorBool:Bool!
    
    @IBOutlet weak var imgBackButton: UIImageView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    var ComingFromLogout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        errorBool = false
        
        //Send it again Button
        
        
        if ComingFromLogout == true {
            
            btnBack.isHidden = true
            
            imgBackButton.isHidden = true
            
        }else {
            
            btnBack.isHidden = false
            
            imgBackButton.isHidden = false
            
        }
        
        
        let buttonTitleStr = NSMutableAttributedString(string:"Forgot your password?", attributes:attrs)
        attributedString.append(buttonTitleStr)
        forgotPwd.setAttributedTitle(attributedString, for: .normal)

        let buttonTitleStr1 = NSMutableAttributedString(string:"Don't have an account?Register here!", attributes:attrs)
        attributedString1.append(buttonTitleStr1)
        btnAlreadyHaveAccount.setAttributedTitle(attributedString1, for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        username.text = "Email id"
        pasword.text = "Password"
    }
    
    //MARK: Tap Gesture
    func handleTap() -> Void
    {
        username.resignFirstResponder()
        pasword.resignFirstResponder()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        self.moveToBackClass()
    }
    
    // MARK :- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(textField == username)
        {
            username.text = ""
            scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
        }
        else
        {
            pasword.text = ""
            pasword.isSecureTextEntry = true
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(username.text?.isEqual(""))!
        {
            username.text = "Email id"
        }
        else if(pasword.text?.isEqual(""))!
        {
            pasword.text = "Password"
            pasword.isSecureTextEntry = false
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField == username)
        {
            pasword.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func signInBtnClick(_ sender: UIButton)
    {
        username.resignFirstResponder()
        pasword.resignFirstResponder()
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            
        if(username.text != "Email id") && (pasword.text != "Password")
        {
            
            hud.show(true)
            hud.frame = self.view.frame
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            hud.color = UIColor.clear
            let udid = UserDefaults.standard.value(forKey: "UID")
            self.view.addSubview(hud)
            self.view.isUserInteractionEnabled = false
           
            if channelId == nil {
                
                channelId = UAirship.push().channelID
            }
            
            let dictUserInfo = ["email":username.text!, "password":pasword.text!, "UU_ID": udid as? String,"secure_token":"CMPS-LniOGl00k", "and_channel_id":channelId] as! [String : String]
            
          //  print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "login.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        alertizenUser.userData(dic: dictReponse)
                        
                        OperationQueue.main.addOperation
                        {
                            self.successStr = dictReponse.object(forKey: "success") as! String!
                            
                            UserDefaults.standard.set(false, forKey:"Facebook")
                                                        
                            self.view.isUserInteractionEnabled = true
                            
                            hud.removeFromSuperview()
                            
                            let udid = UserDefaults.standard.value(forKey: "UID") as! String
                            
                            let userDetails = dictReponse.value(forKey: "userDetails") as! NSDictionary
                            
                            UserDefaults.standard.set("1", forKey: "911_alert_1")
                            
                            UserDefaults.standard.set("1", forKey: "911_alert_2")
                            
                            UserDefaults.standard.set("1", forKey: "911_alert_3")
                            
                            UserDefaults.standard.synchronize()
                            
                            let uid = userDetails.value(forKey: "UU_ID") as! String
                            
                            if uid == udid
                            {
                                self.moveToNextClass()
                            }
                            else
                            {
                                
                                let vc = userVerificationViewController(nibName: "userVerificationViewController", bundle: nil)
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                            }
                        }
                    }
                    else
                    {
                        
                        OperationQueue.main.addOperation
                        {
                            
                            self.errorStr = dictReponse.object(forKey: "error") as! String
                            
                            self.view.isUserInteractionEnabled = true
                            hud.removeFromSuperview()
                          
                            let alertController = UIAlertController(title: "", message: self.errorStr, preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                            {
                               UIAlertAction in
                                
                                if self.errorStr == "Invalid username OR password"
                                {
                                    
                                }
                                else if self.errorStr == "This device is registered with Facebook.  Please login with Facebook."
                                {
                                    
                                }
                                else
                                {
                                    self.moveToBackClass()
                                }
                            }
                            // Add the actions
                            alertController.addAction(okAction)
                            
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
            }, failure:{ (errorMsg) in
                self.view.isUserInteractionEnabled = true
                hud.hide(true)
                hud.removeFromSuperview()
               
                 UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
            else
            {
                UIAlertController.Alert(title: "", msg: "Please Enter Username and Password" , vc: self)
            }
        }
    }
    
    func moveToNextClass()
    {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "campus") as! CampusSelectionVC
        UserDefaults.standard.set(true, forKey:"Login")
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToBackClass() {
        
//        let vcIndex = self.navigationController?.viewControllers.index(where: { (viewController) -> Bool in
//
//            if let _ = viewController as? AuthenticationVC {
//                return true
//            }
//            return false
//        })
//
//        let composeVC = self.navigationController?.viewControllers[vcIndex!] as! AuthenticationVC
        
        self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func btnAlreadyHaveAccount(_ sender: UIButton) {
        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "createProfile") as! CreateProfileVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func forgotPwdBtnClick(_ sender: UIButton)
    {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "forgotPwd") as! ForgotPasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnFbLoginClick(_ sender: Any)
    {
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
       /// fbLoginManager.loginBehavior = FBSDKLoginBehavior.systemAccount
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
    }

    func getFBUserData()
    {
       
         self.isRegisteredForLocalNotifications = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
        
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        self.view.isUserInteractionEnabled = false
        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler: { (connection, result, error) -> Void in
                var dict = NSDictionary()
                dict = result as! NSDictionary
                if (error == nil)
                {
                    var getEmail : String!
                    
                    if channelId == nil
                    {
                        channelId = UAirship.push().channelID
                    }
                    if let strEmail : String = dict.value(forKey: "email") as? String
                    {
                        getEmail = strEmail
                    }
                    else
                    {
                        getEmail = ""
                    }
                    let udid = UserDefaults.standard.value(forKey: "UID")
                  
                    print(dict)
                   // let dictUserInfo = ["fbuserid":dict.value(forKey: "id") as? String,"username":dict.value(forKey: "name") as?String,"email":getEmail,"first_name":dict.value(forKey: "first_name") as?String,"last_name":dict.value(forKey: "last_name") as?String,  "userid": channelId,"UU_ID":udid as? String,"secure_token":"CMPS-FBginlo003"] as! [String : String]
                    let dictUserInfo = ["fbuserid":dict.value(forKey: "id") as? String,"email":getEmail,"first_name":dict.value(forKey: "first_name") as?String,"last_name":dict.value(forKey: "last_name") as?String,  "userid": channelId,"UU_ID":udid as? String,"secure_token":"CMPS-FBginlo003"] as! [String : String]
                    
                    print(dictUserInfo)
                    
                    WebService.sharedInstance.postMethodWithParams(strURL: "fb_login.php", dict: dictUserInfo as NSDictionary, completionHandler:
                        { (dictReponse) in
                           
                            print(dictReponse)
                           
                            if (dictReponse.object(forKey: "success") != nil)
                            {
                                OperationQueue.main.addOperation
                                {
                                    alertizenUser.userData(dic: dictReponse)
                                    UserDefaults.standard.set(true, forKey:"Facebook")
                                    self.view.isUserInteractionEnabled = true
                                    hud.removeFromSuperview()
                                    let udid = UserDefaults.standard.value(forKey: "UID") as! String
                                    let userDetails = dictReponse.value(forKey: "userDetails") as! NSDictionary
                                    
                                    ///
                                    
                                    UserDefaults.standard.set("1", forKey: "911_alert_1")
                                    
                                    UserDefaults.standard.set("1", forKey: "911_alert_2")
                                    
                                    UserDefaults.standard.set("1", forKey: "911_alert_3")
                                    
                                    UserDefaults.standard.synchronize()
                                    
                                    let uid = userDetails.value(forKey: "UU_ID") as! String
                                    
                                    if(self.isRegisteredForLocalNotifications == false)
                                    {
                                        let obj = self.storyboard?.instantiateViewController(withIdentifier: "accept") as! AcceptNotificationsVC
                                        UserDefaults.standard.set(false, forKey:"Login")
                                        self.navigationController?.pushViewController(obj, animated: true)
                                    }
                                    else
                                    {
                                        self.moveToNextClass()
                                    }
                                    
                                   /* if uid == udid
                                    {
                                        
                                        self.moveToNextClass()
                                        
                                    }
                                    else
                                    {
                                        
                                        let vc = userVerificationViewController(nibName: "userVerificationViewController", bundle: nil)
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        
                                    }*/
                                }
                            }
                            else
                            {
                                OperationQueue.main.addOperation
                                    {
                                self.errorStr = dictReponse.object(forKey: "error") as! String

                                // Create the alert controller
                                let alertController = UIAlertController(title: "", message: self.errorStr, preferredStyle: .alert)
                                
                                // Create the actions
                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                                {
                                    UIAlertAction in
                                    self.view.isUserInteractionEnabled = true
                                    
                                    if self.errorStr == "This device is not registered, please register by entering your cell phone number."
                                    {
                                        self.moveToBackClass()
                                    }
                                }
                                // Add the actions
                                alertController.addAction(okAction)
                                   hud.removeFromSuperview()
                                // Present the controller
                                self.present(alertController, animated: true, completion: nil)
                                }
                            }
                    } ,failure:{ (errorMsg) in
                        OperationQueue.main.addOperation
                            {
                        self.view.isUserInteractionEnabled = true
                        
                        UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                                
                        hud.removeFromSuperview()
                        print(errorMsg)
                        }
                        
                    })
                }
            
            })
        }
    }
}
