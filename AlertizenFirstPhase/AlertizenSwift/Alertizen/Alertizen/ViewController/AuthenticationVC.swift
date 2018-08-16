//
//  AuthenticationVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import AirshipKit

class AuthenticationVC: UIViewController,UIScrollViewDelegate,UITextFieldDelegate
{
    @IBOutlet var scrollView: UIScrollView!
   
    @IBOutlet var txtPhoneNumber: UITextField!
    
    @IBOutlet var lblHeading: UILabel!
    
    @IBOutlet var lblEnterPhn: UILabel!
    
    var successStr:String! = nil
 
    var phone:String! = nil
   
    var vcode:NSNumber! = nil
   
    var errorStr:String! = nil

    //MARK: App Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
            
        self.navigationController?.isNavigationBarHidden = true
        
        //Add Tap Gesture to resign Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        let attributes = [NSParagraphStyleAttributeName : style]
        lblHeading.attributedText = NSAttributedString(string: "With alertizen members are notified of a possible crime occurring in their neighborhood within minutes of the 911 call. We'll immediately send you a push notification to your phone with the address and type of crime reported.", attributes:attributes)
        
        lblEnterPhn.attributedText = NSAttributedString(string: "Enter your phone number to create a secure account and become a member of Alertizen.", attributes: attributes)
     }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UserDefaults.standard.set("0", forKey: "phoneVerify")
        UserDefaults.standard.set("0", forKey: "codeentered")
        txtPhoneNumber.text = "Phone Number"
    }
    
    
    //MARK: Tap Gesture
    func handleTap() -> Void
    {
        txtPhoneNumber.resignFirstResponder()
    }

    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(txtPhoneNumber.text? .isEqual("Phone Number"))!
        {
           txtPhoneNumber.text = ""
        }
         scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(txtPhoneNumber.text? .isEqual(""))!
        {
            txtPhoneNumber.text = "Phone Number"
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
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
    
    //MARK: Buttons
    @IBAction func btnNextClick(_ sender: AnyObject)
    {
        txtPhoneNumber.resignFirstResponder()
    
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
        }
        else
        {

        if(txtPhoneNumber.text != "Phone Number") || (txtPhoneNumber.text == "")
        {
            hud.show(true)
            
            hud.frame = self.view.frame
            
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
           
            hud.color = UIColor.clear
            
            if channelId == nil {
              
                channelId = UAirship.push().channelID
            }
            
            self.view.addSubview(hud)
         
            let udid = UserDefaults.standard.value(forKey: "UID")
            
            self.view.isUserInteractionEnabled = false
           
            let dictUserInfo = ["phone":txtPhoneNumber.text!,"UU_ID":udid,"secure_token":"CMPS-DnseOtp0064","and_channel_id":channelId] as! [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "send_otp.php", dict: dictUserInfo as NSDictionary, completionHandler:
            { (dictReponse) in
              
               // print(dictReponse)
            
                if (dictReponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                    {
                        self.phone = dictReponse.object(forKey: "phone") as! String?
                        
                        self.vcode = dictReponse.object(forKey: "vcode") as! NSNumber?
                        
                        self.view.isUserInteractionEnabled = true
                        
                        hud.removeFromSuperview()
                        
                        self.successStr = dictReponse.object(forKey: "success") as! String?
                    
                       // self.view.makeToast(self.vcode.stringValue, duration: 5.0, position: .bottom)
                        
                        // Create the alert controller
                        let alertController = UIAlertController(title: "", message: self.successStr, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {
                            UIAlertAction in
                            
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "userVerification") as! UserVerificationVC
                            
                            obj.phoneStr = self.phone
                            obj.vcodeNum = self.vcode
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
                       
                        let alertController = UIAlertController(title: "", message: self.errorStr, preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                        {
                            UIAlertAction in
                            let obj = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! UserSignInVC
                          
                            self.navigationController?.pushViewController(obj, animated: true)
                        }
                        // Add the actions
                        alertController.addAction(okAction)
                        
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true
                
                hud.removeFromSuperview()
               
                self.showAlertAPIError()
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
    
    //MARK:- Alert
    func showAlertAPIError() {
        
        let alertController = UIAlertController(title: "API Error", message: "There seems to be a problem in fetching the data at the moment. Please try again. ", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            
            self.btnNextClick(self)
        }
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func alrdyMmberBtnClick(_ sender: UIButton)
    {
        //userVerificationViewController
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! UserSignInVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
