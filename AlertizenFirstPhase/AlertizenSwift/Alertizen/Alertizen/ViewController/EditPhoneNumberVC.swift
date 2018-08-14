//
//  EditPhoneNumberVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class EditPhoneNumberVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var textfieldView: UIView!
    @IBOutlet weak var phoneNumTextFld: UITextField!
    
    var successStr:String! = nil
    var phone1:String! = nil
    var vcode:NSNumber! = nil
    
    var errorStr:String! = nil
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        textfieldView.layer.borderColor = UIColor .white.cgColor
        
        textfieldView.layer.borderWidth = 3.0
        
        phoneNumTextFld.text = phone
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        let checkVerification : NSString = UserDefaults.standard.value(forKey:"phoneVerify") as! NSString
        if checkVerification == "1"
        {
            let checkVerify : NSString = UserDefaults.standard.value(forKey:"codeentered") as! NSString
            if checkVerify == "0"
            {
                
            }
            else
            {
                UserDefaults.standard.set("0", forKey: "phoneVerify")
                  UserDefaults.standard.set("0", forKey: "codeentered")
                self.updtephoneno()
            }
            
        }
    }
    //MARK: Tap Gesture
    func handleTap() -> Void
    {
        phoneNumTextFld.resignFirstResponder()
    }
    
    func updateField() -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: TextField Delegate
    @IBAction func textValueChanged(_ sender: UITextField)
    {
        checkMaxLength(textField: sender , maxLength: 9)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int)
    {
        if (textField.text!.characters.count > maxLength)
        {
            textField.resignFirstResponder()
        }
    }
    
    func createOTP() -> Void
    {
            phoneNumTextFld.resignFirstResponder()
            
            let rechability = Reachability.forInternetConnection()
            let remoteHostStatus = rechability?.currentReachabilityStatus()
            
            if (remoteHostStatus == NotReachable)
            {
                UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            }
            else
            {
                //// self.getUUID()
                
                if(phoneNumTextFld.text != "Phone Number") || (phoneNumTextFld.text == "")
                {
                    hud.show(true)
                    hud.frame = self.view.frame
                    hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
                    hud.color = UIColor.clear
                    self.view.addSubview(hud)
                    
                    self.view.isUserInteractionEnabled = false
                    
                    let udid = UserDefaults.standard.value(forKey: "UID")
                    
                    let dictUserInfo = ["phone":phoneNumTextFld.text!,"UU_ID":udid,"secure_token":"CMPS-DnseOtp0064","and_channel_id":channelId] as! [String : String]
                    
//                    let dictUserInfo = ["phone":phoneNumTextFld.text!,"secure_token":"CMPS-DnseOtp0064","and_channel_id":channelId] as! [String : String]
                    
                    WebService.sharedInstance.postMethodWithParams(strURL: "send_otp.php", dict: dictUserInfo as NSDictionary, completionHandler:
                        { (dictReponse) in
                            
                            print(dictReponse)
                            
                            if (dictReponse.object(forKey: "success") != nil)
                            {
                                OperationQueue.main.addOperation
                                    {
                                        self.phone1 = dictReponse.object(forKey: "phone") as! String!
                                        self.vcode = dictReponse.object(forKey: "vcode") as! NSNumber!
                                        
                                        self.view.isUserInteractionEnabled = true
                                        hud.removeFromSuperview()
                                        
                                        self.successStr = dictReponse.object(forKey: "success") as! String!
                                        
                                     //   self.view.makeToast(self.vcode.stringValue, duration: 5.0, position: .bottom)
                                        
                                        // Create the alert controller
                                        let alertController = UIAlertController(title: "", message: self.successStr, preferredStyle: .alert)
                                        
                                        // Create the actions
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                                        {
                                            UIAlertAction in
                                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "userVerification") as! UserVerificationVC
                                            obj.phoneStr = self.phone1
                                            obj.vcodeNum = self.vcode
                                            UserDefaults.standard.set("1", forKey: "phoneVerify")
                                            UserDefaults.standard.set("0", forKey: "codeentered")
                                            self.navigationController?.pushViewController(obj, animated: true)
                                        }
                                        // Add the actions
                                        alertController.addAction(okAction)
                                        
                                        // Present the controller
                                        self.present(alertController, animated: true, completion: nil)
                                }
                            }
                            else
                            {
                                self.errorStr = dictReponse.object(forKey: "error") as! String
                                
                                OperationQueue.main.addOperation
                                    {
                                        self.view.isUserInteractionEnabled = true
                                        hud.removeFromSuperview()
                                        self.showAlert(msg:self.errorStr)
                                }
                            }
                            
                    }, failure:{ (errorMsg) in
                        self.view.isUserInteractionEnabled = true
                        hud.removeFromSuperview()
                        
                        UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                    })
                }
                else
                {
                    self.showAlert(msg:"Please fill the data.")
                }
            }
        }
    
    func updtephoneno() -> Void {
        
        phoneNumTextFld.resignFirstResponder()
        
        if (phoneNumTextFld.text != phone) {
           
            hud.show(true)
           
            hud.frame = self.view.frame
            
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            
            hud.color = UIColor.clear
            
            self.view.addSubview(hud)
           
            self.view.isUserInteractionEnabled = false
            
            let userDetails_Dict =  NSMutableDictionary()
            
            let temp_Dict = NSMutableDictionary()
            
            let dictUserInfo = ["data_name":"phone","data_value":phoneNumTextFld.text!,"userId":userId,"secure_token":"CMPS-UpProatele"] as [String : String]
            
            print(dictUserInfo)
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let detail_Dict = detail["userDetails"] as! NSDictionary
            
            temp_Dict.addEntries(from: detail_Dict as! [AnyHashable : Any])
            
            temp_Dict.setValue(phoneNumTextFld.text, forKey: "phone")
            
            userDetails_Dict.setValue(temp_Dict, forKey: "userDetails")
            
            alertizenUser.userData(dic: userDetails_Dict)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "update_profile.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil) {
                        
                        OperationQueue.main.addOperation {
                            
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
    }
    @IBAction func tickBtnClick(_ sender: UIButton)
    {
        self.createOTP()
    }
    
    func moveToPreviousClass()
    {
        let _ = self.navigationController?.popViewController(animated: true)
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
    @IBAction func btnInboxClick(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editProfile = storyboard.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
        self.navigationController?.pushViewController(editProfile, animated: false)
    }
}
