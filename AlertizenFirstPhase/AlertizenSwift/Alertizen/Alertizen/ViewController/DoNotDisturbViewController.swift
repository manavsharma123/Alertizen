//
//  DoNotDisturbViewController.swift
//  Alertizen
//
//  Created by MR on 24/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class DoNotDisturbViewController: UIViewController {

    @IBOutlet weak var switchAction: UISwitch!

    @IBOutlet var switchScheduledAction: UISwitch!
    
    @IBOutlet var viewTimer: UIView!
    
    @IBOutlet var lblFrom: UILabel!
    
    @IBOutlet var lblTo: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if (UserDefaults.standard.bool(forKey: "dontDisturb") == true)
        {
            self.switchAction.setOn(true, animated: true)
        }
        else
        {
            self.switchAction.setOn(false, animated: true)
        }
        
        if (UserDefaults.standard.bool(forKey: "Scheduled") == true)
        {
            self.switchScheduledAction.setOn(true, animated: true)
            viewTimer.isHidden = false
        }
        else
        {
            self.switchScheduledAction.setOn(false, animated: true)
            viewTimer.isHidden = true
        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        if let strFrom : String =  UserDefaults.standard.value(forKey: "From") as! String?
        {
            lblFrom.text = strFrom
        }
        if let strTo : String = UserDefaults.standard.value(forKey: "To") as! String?
        {
            lblTo.text = strTo
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ToggleSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            let rechability = Reachability.forInternetConnection()
            let remoteHostStatus = rechability?.currentReachabilityStatus()
            
            if (remoteHostStatus == NotReachable)
            {
                UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            }
            else
            {
                if switchScheduledAction.isOn == true
                {
                    viewTimer.isHidden = false
                }
                else
                {
                    viewTimer.isHidden = true
                }
                
            self.view.isUserInteractionEnabled = false

                hud.show(true)
                hud.frame = self.view.frame
                hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
                hud.color = UIColor.clear
                self.view.addSubview(hud)
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
                
            let dictUserInfo = ["userId":detail_Dict,"phone":phnNo,"dnd_status":"1","from_time":"","to_time":"","device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-DND00St44"] as [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "dnd_status.php" , dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
                
                print(dictResponse)
                
                if (dictResponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                            hud.removeFromSuperview()
                            
                            self.view.isUserInteractionEnabled = true
                            
                            UserDefaults.standard.set(true, forKey:"dontDisturb")
                            
                            UserDefaults.standard.set(false, forKey:"Scheduled")

                        }
                }
                else
                {
                    hud.removeFromSuperview()
                    self.view.isUserInteractionEnabled = true
                }
                
            }, failure:{ (errorMsg) in
                self.view.isUserInteractionEnabled = true
                hud.removeFromSuperview()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
                
            }
          
        }
        else
        {
            if switchScheduledAction.isOn == false
            {
            let rechability = Reachability.forInternetConnection()
            let remoteHostStatus = rechability?.currentReachabilityStatus()
            
            if (remoteHostStatus == NotReachable)
            {
                UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
                
            }
            else
            {
            
            self.view.isUserInteractionEnabled = false

                hud.show(true)
                hud.frame = self.view.frame
                hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
                hud.color = UIColor.clear
                self.view.addSubview(hud)

            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
                
            let dictUserInfo = ["userId":detail_Dict,"phone":phnNo,"dnd_status":"0","from_time":"","to_time":"","device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-DND00St44"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "dnd_status.php" , dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
                
                print(dictResponse)
                
                if (dictResponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                            hud.removeFromSuperview()
                            
                            self.view.isUserInteractionEnabled = true

                            UserDefaults.standard.set(false, forKey:"dontDisturb")

                        }
                    
                }
                else
                {
                    hud.removeFromSuperview()
                    
                    self.view.isUserInteractionEnabled = true
                }
                
            }, failure:{ (errorMsg) in
                self.view.isUserInteractionEnabled = true
                hud.removeFromSuperview()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
          }
         }
            else
            {
                UserDefaults.standard.set(false, forKey:"dontDisturb")
            }
       }
    }
    
    @IBAction func ToggleScheduledSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            self.switchAction.setOn(true, animated: true)
           
            viewTimer.isHidden = false
            
            self.view.isUserInteractionEnabled = false
            
            hud.show(true)
            
            hud.frame = self.view.frame
            
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            
            hud.color = UIColor.clear
            
            self.view.addSubview(hud)
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let dictUserInfo = ["userId":detail_Dict,"phone":phnNo,"dnd_status":"1","from_time":(lblFrom.text)!,"to_time":(lblTo.text)!,"device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-DND00St44"] as [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "dnd_status.php" , dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
                
                print(dictResponse)
                
                if (dictResponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                            hud.removeFromSuperview()
                            
                            self.view.isUserInteractionEnabled = true
                            
                            UserDefaults.standard.set(true, forKey:"Scheduled")
                            
                            UserDefaults.standard.set(true, forKey:"dontDisturb")
                            
                        }
                }
                else
                {
                    hud.removeFromSuperview()
                    
                    self.view.isUserInteractionEnabled = true
                }
                
            }, failure:{ (errorMsg) in
                self.view.isUserInteractionEnabled = true
                hud.removeFromSuperview()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
        else
        {
            self.switchAction.setOn(false, animated: true)
            viewTimer.isHidden = true
            self.view.isUserInteractionEnabled = false
            
            hud.show(true)
            hud.frame = self.view.frame
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            hud.color = UIColor.clear
            self.view.addSubview(hud)
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let dictUserInfo = ["userId":detail_Dict,"phone":phnNo,"dnd_status":"0","from_time":"","to_time":"","device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-DND00St44"] as [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "dnd_status.php" , dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
                
                print(dictResponse)
                
                if (dictResponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                           hud.removeFromSuperview()
                            
                            self.view.isUserInteractionEnabled = true
                            
                            UserDefaults.standard.set(false, forKey:"Scheduled")
                            
                            UserDefaults.standard.set(false, forKey:"dontDisturb")
                            
                        }
                }
                else
                {
                    hud.removeFromSuperview()
                    
                    self.view.isUserInteractionEnabled = true
                }
                
            }, failure:{ (errorMsg) in
                self.view.isUserInteractionEnabled = true
                hud.removeFromSuperview()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }

    }
    
    @IBAction func btnScheduledAction(_ sender: UIButton) -> Void
    {
        let vc = ScheduledViewController(nibName: "ScheduledViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnInboxClick(_ sender: UIButton) -> Void {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let editProfile = storyboard.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
        
        self.navigationController?.pushViewController(editProfile, animated: false)
    }
    

}
