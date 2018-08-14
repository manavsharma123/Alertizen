//
//  DontDistrubViewController.swift
//  Alertizen
//
//  Created by Mac OSX on 11/05/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

class DontDistrubViewController: UIViewController {
    
    @IBOutlet weak var switchFirstAction: UISwitch!
    
    @IBOutlet var switchSecondAction: UISwitch!
    
    @IBOutlet var switchThirdAction: UISwitch!
    
    @IBOutlet var lblfirst: UILabel!
    
    @IBOutlet var lblSecond: UILabel!
    
    @IBOutlet var lblThird: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.get_titles()
       
        let alert1 = UserDefaults.standard.value(forKey: "911_alert_1") as! String
    
        let alert2 = UserDefaults.standard.value(forKey: "911_alert_2") as! String
        
        let alert3 = UserDefaults.standard.value(forKey: "911_alert_3") as! String
        
        if alert1 == "0"
        {
              switchFirstAction.setOn(false, animated: true);
        }
        else
        {
              switchFirstAction.setOn(true, animated: true);
        }
        
        if alert2 == "0"
        {
              switchSecondAction.setOn(false, animated: true);
        }
        else
        {
              switchSecondAction.setOn(true, animated: true);
        }
        
        if alert3 == "0"
        {
              switchThirdAction.setOn(false, animated: true);
        }
        else
        {
              switchThirdAction.setOn(true, animated: true);
        }
            // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
       
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ToggleSecondSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            self.updatestatus_api(titlenumber: "2", status: "1")
        }
        else
        {
            self.updatestatus_api(titlenumber: "2", status: "0")
        }
    }
    
    @IBAction func ToggleFirstSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            self.updatestatus_api(titlenumber: "1", status: "1")
        }
        else
        {
            self.updatestatus_api(titlenumber: "1", status: "0")
        }
    }
    
    @IBAction func ToggleThirdSwitch(_ sender: UISwitch)
    {
        if sender.isOn
        {
            self.updatestatus_api(titlenumber: "3", status: "1")
        }
        else
        {
            self.updatestatus_api(titlenumber: "3", status: "0")
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func get_titles() -> Void
    {
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
        }
        else
        {
            hud.show(true)
            
            hud.frame = self.view.frame
            
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            
            hud.color = UIColor.clear
            
            self.view.addSubview(hud)
            
            let dictUserInfo = ["secure_token":"CMPS-AlSertetti"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "alert_setting.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    OperationQueue.main.addOperation
                    {
                            let success = dictReponse.value(forKey: "success")
                            
                            var resultString : String!
                            
                            resultString = success as! String
                            
                            if resultString == "Successfully!"
                            {
                                var dic = NSDictionary()
                                
                                dic = dictReponse.value(forKey: "setting")
                                as! NSDictionary
                                
                                self.lblDescription.text = dic.value(forKey: "description") as? String
                                
                                self.lblfirst.text = dic.value(forKey: "title_1") as? String
                                
                                self.lblSecond.text = dic.value(forKey: "title_2") as? String
                                
                                self.lblThird.text =  dic.value(forKey: "title_3") as? String
                            }
                            else
                            {
                                UIAlertController.Alert(title: "Alert", msg: "No data available", vc: self)
                            }
                            
                            hud.removeFromSuperview()
                            
                    }
                    
            }, failure:{ (errorMsg) in
                
                UIAlertController.Alert(title: "Alert", msg: errorMsg, vc: self)
                hud.removeFromSuperview()
            })
            
        }
    }

    func updatestatus_api(titlenumber:String,status:String) -> Void
    {
        
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            
            hud.show(true)
            
            hud.frame = self.view.frame
            
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            
            hud.color = UIColor.clear
            
            self.view.addSubview(hud)
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let userID = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let dictUserInfo : [String: String] =  ["userId":userID,"phone":phnNo,"setting":titlenumber,"status":status,"secure_token":"CMPS-St911us4"]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "911_status.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                
                    OperationQueue.main.addOperation
                    {
                        if titlenumber == "1"
                        {
                            UserDefaults.standard.set(status, forKey: "911_alert_1")
                        }
                        if titlenumber == "2"
                        {
                             UserDefaults.standard.set(status, forKey: "911_alert_2")
                        }
                        if titlenumber == "3"
                        {
                             UserDefaults.standard.set(status, forKey: "911_alert_3")
                        }
                        
                        UserDefaults.standard.synchronize()
                        
                        hud.hide(true)
                        hud.removeFromSuperview()
                    }
                    
                    
                    
            }, failure:{ (errorMsg) in
                
                hud.hide(true)
                hud.removeFromSuperview()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
    }
}
