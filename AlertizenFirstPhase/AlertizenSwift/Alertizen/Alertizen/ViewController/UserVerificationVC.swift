//
//  UserVerificationVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class UserVerificationVC: UIViewController,UITextFieldDelegate
{
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        phoneNoLbl.text = phoneStr
        
        vcodeStr = vcodeNum.stringValue
        
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
            hud.show(true)
            hud.frame = self.view.frame
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            hud.color = UIColor.clear
            self.view.addSubview(hud)
            
            self.view.isUserInteractionEnabled = false
            
             let udid = UserDefaults.standard.value(forKey: "UID")
            
               let dictUserInfo = ["phone":phoneStr,"UU_ID":udid,"secure_token":"CMPS-DnseOtp0064","and_channel_id":channelId] as! [String : String]
            
//            let dictUserInfo = ["phone":phoneStr,"secure_token":"CMPS-DnseOtp0064","and_channel_id":channelId] as! [String : String]
//
            WebService.sharedInstance.postMethodWithParams(strURL: "send_otp.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                  
                    ///print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                            {
                                self.vcode = dictReponse.object(forKey: "vcode") as! NSNumber?
                
                                self.view.isUserInteractionEnabled = true
                                hud.removeFromSuperview()
                                
                                self.successStr = dictReponse.object(forKey: "success") as! String?
                                
                                self.showAlert(msg:self.successStr)

                               // self.view.makeToast(self.vcode.stringValue, duration:5.0, position: .bottom)
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
    }
    
    @IBAction func changePhNoBtnClick(_ sender: UIButton)
    {
         self.navigationController?.popViewController(animated: false)
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
            hud.show(true)
            hud.frame = self.view.frame
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            hud.color = UIColor.clear
            self.view.addSubview(hud)
            self.view.isUserInteractionEnabled = false
            let dictUserInfo = ["phone":phoneStr,"vcode":txtVerifyCode.text!,"secure_token":"CMPS-OtFypErvi"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "verify_otp.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                  
                    //  print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                        {
                            self.view.isUserInteractionEnabled = true
                            hud.removeFromSuperview()
                            self.successStr = dictReponse.object(forKey: "success") as! String!
                            let checkVerification : NSString = UserDefaults.standard.value(forKey:"phoneVerify") as! NSString
                            if checkVerification == "0"
                            {
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "termCondition") as! TermsNConditionsVC
                                obj.phone = self.phoneStr
                                self.navigationController?.pushViewController(obj, animated: true)
                            }
                            else
                            {
                                UserDefaults.standard.set("1", forKey: "codeentered")
                                self.navigationController?.popViewController(animated: true)
                            }
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
