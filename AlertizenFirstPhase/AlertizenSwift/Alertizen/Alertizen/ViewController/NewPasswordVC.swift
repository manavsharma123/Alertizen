//
//  NewPasswordVC.swift
//  Alertizen
//
//  Created by Apple on 26/02/18.
//  Copyright © 2018 Mind Roots Technologies. All rights reserved.
//

import UIKit
import AirshipKit
class NewPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView:UIScrollView!
    
    @IBOutlet weak var username:UITextField!
    
    @IBOutlet weak var pasword:UITextField!
    
    var phoneStr:String! = nil
    
    var errorStr:String! = nil
    
    var successStr:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        username.text = "New Password"
        
        pasword.text = "Confirm Password"
    }
    
    //MARK: Tap Gesture
    func handleTap() -> Void {
        
        username.resignFirstResponder()
        
        pasword.resignFirstResponder()
    }
    
    // MARK:- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == username) {
            
            username.text = ""
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
            
            username.isSecureTextEntry = true
        }
        else {
            
            pasword.text = ""
            
            pasword.isSecureTextEntry = true
            
            scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(username.text?.isEqual(""))! {
            
            username.text = "New Password"
            
            username.isSecureTextEntry = false
        }
        else if(pasword.text?.isEqual(""))! {
            
            pasword.text = "Confirm Password"
            
            pasword.isSecureTextEntry = false
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if(textField == username) {
            
            pasword.becomeFirstResponder()
        }
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    //MARK: Buttons
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInBtnClick(_ sender: UIButton) {
        
        username.resignFirstResponder()
        
        pasword.resignFirstResponder()
        
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable) {
            
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
        }
        else {
            
            if(username.text != "New Password") && (pasword.text != "Confirm Password") {
              
                SVProgressHUD.show()
                
                self.view.isUserInteractionEnabled = false
                
                let udid = UserDefaults.standard.value(forKey: "UID")
                
                let dictUserInfo = ["password":username.text!,"con_password":pasword.text!,"phone":phoneStr, "UU_ID":udid] as! [String : String]
                
                print(dictUserInfo)
                
                WebService.sharedInstance.postMethodWithParams(strURL: "reset_password.php", dict: dictUserInfo as NSDictionary, completionHandler:
                    { (dictReponse) in
                        
                        print(dictReponse)
                        
                        if (dictReponse.object(forKey: "success") != nil) {
                            
                            OperationQueue.main.addOperation {
                                
                                self.successStr = dictReponse.object(forKey: "success") as! String!
                                
                                SVProgressHUD.dismiss()
                                
                                  // Create the alert controller
                                 let alertController = UIAlertController(title: "", message: self.successStr, preferredStyle: .alert)
                                 
                                 // Create the actions
                                 let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                 
                                 UIAlertAction in
                                 
                                    self.moveToNextClass()
                                 }
                                 // Add the actions
                                 alertController.addAction(okAction)
                                 
                                 // Present the controller
                                 self.present(alertController, animated: true, completion: nil)
                                
                                self.view.isUserInteractionEnabled = true
                            }
                        }
                        else {
                            
                            self.errorStr = dictReponse.object(forKey: "error") as! String
                            
                            OperationQueue.main.addOperation {
                                
                                self.view.isUserInteractionEnabled = true
                                
                                SVProgressHUD.dismiss()
                                
                                UIAlertController.Alert(title: self.errorStr, msg: "" , vc: self)
                              
                            }
                        }
                }, failure:{ (errorMsg) in
                    
                    self.view.isUserInteractionEnabled = true
                    
                    SVProgressHUD.dismiss()
                    
                    UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                })
            }
            else {
                
                UIAlertController.Alert(title: "", msg: "Please Enter Password" , vc: self)
            }
        }
    }
    
    func moveToNextClass() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "signIn") as! UserSignInVC
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
