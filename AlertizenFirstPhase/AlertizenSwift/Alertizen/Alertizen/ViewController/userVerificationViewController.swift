//
//  userVerificationViewController.swift
//  Alertizen
//
//  Created by MR 2 on 07/03/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit
import AirshipKit
class userVerificationViewController: UIViewController {

    
    var successStr:String! = nil
    var phone:String! = nil
    var vcode:NSNumber! = nil
    var errorStr:String! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yesBtnClick(_ sender: UIButton)
    {
        
        self.getotp()
 
        
    }
    
    func getotp() -> Void {
        
            let rechability = Reachability.forInternetConnection()
        
            let remoteHostStatus = rechability?.currentReachabilityStatus()
            
            if (remoteHostStatus == NotReachable)
            {
                UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            }
            else {
               
                self.getUUID()
                
                SVProgressHUD.show()
                    
                self.view.isUserInteractionEnabled = false
                
                let dic = UserDefaults.standard.value(forKey: "getUserDetails") as! NSDictionary
                
                let userDetails = dic.value(forKey: "userDetails") as! NSDictionary
                
                let user = userDetails.value(forKey: "username")
                
                let phone = userDetails.value(forKey: "phone")
                
                let udid = UserDefaults.standard.value(forKey: "UID")
                
                let dictUserInfo = ["phone":phone as! String,"username":user! as! String,"secure_token":"CMPS-OtpnewDevic009A8", "UU_ID":udid, "and_channel_id":channelId] as! [String : String]
                
                WebService.sharedInstance.postMethodWithParams(strURL: "send_otp_new_device.php", dict: dictUserInfo as NSDictionary, completionHandler:
                        { (dictReponse) in
                            
                            print(dictReponse)
                            
                            if (dictReponse.object(forKey: "success") != nil)
                            {
                                OperationQueue.main.addOperation
                                    {
                                        self.phone = dictReponse.object(forKey: "phone") as! String!
                                        self.vcode = dictReponse.object(forKey: "vcode") as! NSNumber!
                                        
                                        self.view.isUserInteractionEnabled = true
                                        SVProgressHUD.dismiss()
                                        
                                        self.successStr = dictReponse.object(forKey: "success") as! String!
                                        
                                        //self.view.makeToast(self.vcode.stringValue, duration: 5.0, position: .bottom)
                                        
                                        // Create the alert controller
                                        let alertController = UIAlertController(title: "", message: self.successStr, preferredStyle: .alert)
                                        
                                        // Create the actions
                                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                                        {
                                            UIAlertAction in
                                            let vc = newUserVerificationViewController(nibName: "newUserVerificationViewController", bundle: nil)
                                            vc.phoneStr = self.phone
                                            vc.vcodeNum = self.vcode
                                            self.navigationController?.pushViewController(vc, animated: true)
                                            
                                            
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
    
    func getUUID() -> Void
    {
        if channelId == nil
        {
            channelId = UAirship.push().channelID
        }
    }
    //MARK: AlertController
    
    func showAlert(msg:String) -> Void
    {
        UIAlertController.Alert(title: "", msg: msg, vc: self)
    }
    
    
    @IBAction func noBtnClick(_ sender: UIButton)
    {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
