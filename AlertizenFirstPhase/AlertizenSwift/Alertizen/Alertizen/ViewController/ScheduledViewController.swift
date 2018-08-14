//
//  ScheduledViewController.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 22/12/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class ScheduledViewController: UIViewController {
    
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var btnTo: UIButton!
    
    @IBOutlet var btnFrom: UIButton!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        if let strFrom : String =  UserDefaults.standard.value(forKey: "From") as! String? {
            
            btnFrom.setTitle(String(format:"From %@",strFrom), for:.normal)
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat =  "hh:mm a"
            
            let date = dateFormatter.date(from: strFrom)
            
            datePicker.date = date!
        }
        if let strTo : String = UserDefaults.standard.value(forKey: "To") as! String?
        {
            btnTo.setTitle(String(format:"To %@",strTo), for:.normal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            let strFrom : String =  (UserDefaults.standard.value(forKey: "From") as! String?)!
            let strTo : String = (UserDefaults.standard.value(forKey: "To") as! String?)!
            
            if (strFrom != strTo)
            {
                
                self.view.isUserInteractionEnabled = false
                
                hud.show(true)
                hud.frame = self.view.frame
                hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
                hud.color = UIColor.clear
                self.view.addSubview(hud)
                
                let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
                
                let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
                
                let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
                
                let dictUserInfo = ["userId":detail_Dict,"phone":phnNo,"dnd_status":"1","from_time":(UserDefaults.standard.value(forKey: "From") as! String?)!,"to_time":(UserDefaults.standard.value(forKey: "To") as! String?)!,"device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-DND00St44"] as [String : String]
                
                print(dictUserInfo)
                
                WebService.sharedInstance.postMethodWithParams(strURL: "dnd_status.php" , dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
                    
                    print(dictResponse)
                    
                    if (dictResponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation {
                            
                                hud.removeFromSuperview()
                                
                                self.view.isUserInteractionEnabled = true
                                
                                let _ = self.navigationController?.popViewController(animated: true)
                                
                        }
                    }
                    else
                    {
                        hud.removeFromSuperview()
                        
                        self.view.isUserInteractionEnabled = true
                        
                        UIAlertController.Alert(title: "", msg: dictResponse.object(forKey: "error") as! String, vc: self)
                    }
                    
                }, failure:{ (errorMsg) in
                    self.view.isUserInteractionEnabled = true
                    hud.removeFromSuperview()
                    
                    UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                })
            }
            else
            {
                UIAlertController.Alert(title: "", msg: "Please select different times for FROM & TO", vc: self)
            }
        }
        
    }

    @IBAction func datePickerAction(_ sender: Any)
    {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .short
        
        if btnFrom.isSelected == true
        {
            let strFrom = String(format:"From %@",dateFormatter.string(from: (sender as AnyObject).date))
            btnFrom.setTitle(strFrom, for:.normal)
            UserDefaults.standard.set(dateFormatter.string(from: (sender as AnyObject).date), forKey:"From")
        }
        else
        {
            let strTo = String(format:"To %@",dateFormatter.string(from: (sender as AnyObject).date))
            btnTo.setTitle(strTo, for:.normal)
            UserDefaults.standard.set(dateFormatter.string(from: (sender as AnyObject).date), forKey:"To")
        }
        
    }
    
    
    @IBAction func btnStartAction(_ sender: UIButton) -> Void
    {
        if let strFrom : String =  UserDefaults.standard.value(forKey: "From") as! String?
        {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat =  "hh:mm a"
            
            let date = dateFormatter.date(from: strFrom)
            
            datePicker.date = date!
        }
        
        btnFrom.isSelected = true
        
        btnFrom.backgroundColor = UIColor(red: 205.0/255, green: 205.0/255, blue: 205.0/255, alpha: 1)
        
        btnTo.backgroundColor = UIColor.white
    }
    
    
    @IBAction func btnEndAction(_ sender: UIButton) -> Void
    {
        if let strTo : String =  UserDefaults.standard.value(forKey: "To") as! String?
        {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat =  "hh:mm a"
            
            let date = dateFormatter.date(from: strTo)
            
            datePicker.date = date!
        }
        
        btnFrom.isSelected = false
        
        btnTo.backgroundColor = UIColor(red: 205.0/255, green: 205.0/255, blue: 205.0/255, alpha: 1)
        
        btnFrom.backgroundColor = UIColor.white
        
    }
    
}
