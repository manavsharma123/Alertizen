//
//  newUserVerificationViewController.swift
//  Alertizen
//
//  Created by MR 2 on 14/03/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

class newUserVerificationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var txtVerifyCode: UITextField!
    
    @IBOutlet var svMainVerification: UIScrollView!
    
    @IBOutlet weak var sendItAgnVw:UIView!
    
    @IBOutlet weak var sendItAgn : UIButton!
    
    @IBOutlet weak var resendTo: UILabel!
    
    @IBOutlet weak var whiteTransparentVw : UIView!
    
    @IBOutlet weak var phoneNoLbl:UILabel!
    
    var attrs = [
        NSForegroundColorAttributeName : UIColor.red,
        NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
        ] as [String : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    var phoneStr:String! = nil
    var vcodeNum:NSNumber! = nil
    var vcodeStr:String! = nil
    
    var successStr:String! = nil
    var vcode:NSNumber! = nil
    var errorStr:String! = nil
    var strView = String()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        phoneNoLbl.text = phoneStr
        
        if strView != "Forgot" {
            
            vcodeStr = vcodeNum.stringValue
        }
        /*else {
            
            self.view.makeToast(vcodeStr, duration: 5.0, position: .bottom)
        }*/
        //Send it again Button
        let buttonTitleStr = NSMutableAttributedString(string:"Send it again, I didn't receive it.", attributes:attrs)
        attributedString.append(buttonTitleStr)
        sendItAgn.setAttributedTitle(attributedString, for: .normal)
        
        //Resend to label
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        
        let underlineAttributedString = NSAttributedString(string: "Resend to:", attributes: underlineAttribute)
        
        resendTo.attributedText = underlineAttributedString
        
        //White Transparent View
        self.whiteTransparentVw.layer.borderWidth = 1
        self.whiteTransparentVw.layer.borderColor = UIColor(red:228.0/255.0, green:70.0/255.0, blue:62.0/255.0, alpha: 1.0).cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func handleTap() -> Void
    {
        txtVerifyCode.resignFirstResponder()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK :- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(txtVerifyCode.text? .isEqual("Verification Code"))!
        {
            txtVerifyCode.text = ""
        }
        svMainVerification.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(txtVerifyCode.text? .isEqual(""))!
        {
            txtVerifyCode.text = "Verification Code"
        }
        svMainVerification.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton)
    {
        sendItAgnVw.isHidden = true
    }
    
    @IBAction func textValueChanged(_ sender: UITextField)
    {
        checkMaxLength(textField: sender,maxLength: 4)
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int)
    {
        if (textField.text!.characters.count > maxLength)
        {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func sendItAgnBtnClick(_ sender: UIButton)
    {
        txtVerifyCode.resignFirstResponder()
        sendItAgnVw.isHidden = false
    }
    
    @IBAction func sendByTxtMsgBtnClick(_ sender: UIButton)
    {
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
        }
        else
        {
            sendItAgnVw.isHidden = true
            SVProgressHUD.show()
            self.view.isUserInteractionEnabled = false
           
            let dic = UserDefaults.standard.value(forKey: "getUserDetails") as! NSDictionary
            
            let userDetails = dic.value(forKey: "userDetails") as! NSDictionary
            
            let user = userDetails.value(forKey: "username")
           
            let udid = UserDefaults.standard.value(forKey: "UID")
            
            let dictUserInfo = ["phone":phoneStr, "username":user as! String, "secure_token":"CMPS-OtpnewDevic009A8", "UU_ID":udid, "and_channel_id":channelId] as! [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "send_otp_new_device.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                            {
                                self.vcode = dictReponse.object(forKey: "vcode") as! NSNumber!
                                
                                self.view.isUserInteractionEnabled = true
                                SVProgressHUD.dismiss()
                                
                                self.successStr = dictReponse.object(forKey: "success") as! String!
                                
                                self.showAlert(msg:self.successStr)
                                
                              //  self.view.makeToast(self.vcode.stringValue, duration:5.0, position: .bottom)
                        }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        OperationQueue.main.addOperation
                            {
                                self.view.isUserInteractionEnabled = true
                                SVProgressHUD.dismiss()
                                self.showAlert(msg:self.errorStr)
                        }
                    }
            }, failure:{ (errorMsg) in
                self.view.isUserInteractionEnabled = true
                SVProgressHUD.dismiss()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
    }
    
    @IBAction func changePhNoBtnClick(_ sender: UIButton)
    {
        let _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnNextClick(_ sender: AnyObject)
    {
        txtVerifyCode.resignFirstResponder()
        
        print(txtVerifyCode.text!)
        
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
        }
        else
        {
            
            if(txtVerifyCode.text != "Verification Code") || (txtVerifyCode.text == "")
            {
                SVProgressHUD.show()
                
                self.view.isUserInteractionEnabled = false
                let uid = UserDefaults.standard.value(forKey: "UID") as! String
                
                var strURl = String()
                
                var dictUserInfo = [String:String]()
                
                if strView == "Forgot" {
                    
                    strURl = "verify_otp_forgot.php"
                    
                    dictUserInfo = ["phone":phoneStr,"vcode":txtVerifyCode.text!, "UU_ID":uid] as [String : String]
                }
                else {
                    
                    let dic = UserDefaults.standard.value(forKey: "getUserDetails") as! NSDictionary
                    
                    let userDetails = dic.value(forKey: "userDetails") as! NSDictionary
                    
                    let user = userDetails.value(forKey: "username")
                    
                    strURl = "verify_otp_ios_device.php"
                    
                    dictUserInfo = ["phone":phoneStr,"vcode":txtVerifyCode.text!,"username":user as! String,"device_token":uid,"secure_token":"CMPS-Ver009fiDece"] as [String : String]
                }
                
                print(dictUserInfo)
                
                WebService.sharedInstance.postMethodWithParams(strURL:                     strURl, dict: dictUserInfo as NSDictionary, completionHandler:
                    { (dictReponse) in
                        
                          print(dictReponse)
                        
                        if (dictReponse.object(forKey: "success") != nil)
                        {
                            OperationQueue.main.addOperation
                                {
                                    self.view.isUserInteractionEnabled = true

                                    self.txtVerifyCode.resignFirstResponder()
                                    SVProgressHUD.dismiss()
                                    
                                    if self.strView == "Forgot" {
                                        
                                        let vc = NewPasswordVC(nibName: "NewPasswordVC", bundle: nil)
                                        
                                        vc.phoneStr = self.phoneStr
                                     
                                        self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                    else {
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier: "campus") as! CampusSelectionVC
                                    UserDefaults.standard.set(true, forKey:"Login")
                                    
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                    }
                                    
                                }
                        }
                        else
                        {
                            self.errorStr = dictReponse.object(forKey: "error") as! String
                            OperationQueue.main.addOperation
                            {
                                    self.view.isUserInteractionEnabled = true
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
    }
    
    //MARK: AlertController
    func showAlert(msg:String) -> Void
    {
        UIAlertController.Alert(title: "", msg: msg, vc: self)
    }
    
}
