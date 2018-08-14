//
//  ForgotPasswordVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController,UITextFieldDelegate
{
    @IBOutlet var txtPhoneNumber: UITextField!    //emailAddress Field 8 August
    
    @IBOutlet var scrollView: UIScrollView!
    
    var successStr:String! = nil
    var password = Int()
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
    
    
    func handleTap() -> Void
    {
        txtPhoneNumber.resignFirstResponder()
    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
       let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(txtPhoneNumber.text? .isEqual("Email address"))!
        {
            txtPhoneNumber.text = ""
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(txtPhoneNumber.text? .isEqual(""))!
        {
            txtPhoneNumber.text = "Email address"
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    @IBAction func textValueChanged(_ sender: UITextField)
    {
//      checkMaxLength(textField: sender , maxLength: 9)
    }

    
    
   func checkMaxLength(textField: UITextField!, maxLength: Int)
   {
      if (textField.text!.count > maxLength)
      {
        textField.resignFirstResponder()
      }
   }

    // 8 August
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        txtPhoneNumber.resignFirstResponder()
        return true
    }
    
    @IBAction func submitBtnCLick(_ sender: UIButton)
    {
        txtPhoneNumber.resignFirstResponder() //emailAddress Field 8 August
        
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        // 8 August
        let strEmail = txtPhoneNumber.text?.Trim()
        
        guard (strEmail?.isValidEmail())! else{
        
              UIAlertController.Alert(title: "", msg: "Please enter valid Email address", vc: self)
            return
        }
      
        
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
        
        if(txtPhoneNumber.text != "Email address") || (txtPhoneNumber.text == "")
        {
            hud.show(true)
            hud.frame = self.view.frame
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            hud.color = UIColor.clear
            self.view.addSubview(hud)
            self.view.isUserInteractionEnabled = false
            
            let udid = UserDefaults.standard.value(forKey: "UID")
            
            let dictUserInfo = ["email":txtPhoneNumber.text!,"secure_token":"CMPS-Got009Pass123", "UU_ID":udid] as! [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "forgotpass.php", dict: dictUserInfo as NSDictionary, completionHandler:
            { (dictReponse) in
           
            print(dictReponse)
                
            if (dictReponse.object(forKey: "success") != nil)
            {
              OperationQueue.main.addOperation
              {
                print(dictReponse)
                
                self.password = dictReponse.object(forKey: "vcode") as! Int
                
                self.successStr = dictReponse.object(forKey: "success") as! String?
                
                self.view.isUserInteractionEnabled = true
                
                hud.removeFromSuperview()
                
                let vc = newUserVerificationViewController(nibName: "newUserVerificationViewController", bundle: nil)
                
                vc.strView = "Forgot"
                
                vc.phoneStr = self.txtPhoneNumber.text
                
                vc.vcodeStr = String(self.password)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
               // self.view.makeToast(self.password, duration: 5.0, position: .bottom)
                
              //  _ =  Timer.scheduledTimer(timeInterval:1.0, target: self, selector: #selector(ForgotPasswordVC.moveToPreviousClass), userInfo: nil, repeats: false)
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
            }, failure:{(errorMsg) in
            
                print(errorMsg as? String)
                
                 UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
            
        else
        {
            self.showAlert(msg:"Please fill the data.")
        }
            
      }
        
    }

    
  func moveToPreviousClass()
  {
     self.navigationController?.popViewController(animated: true)
  }

    
  //MARK: AlertController
  func showAlert(msg:String) -> Void
  {
        UIAlertController.Alert(title: "", msg: msg, vc: self)
  }
    
    
}
