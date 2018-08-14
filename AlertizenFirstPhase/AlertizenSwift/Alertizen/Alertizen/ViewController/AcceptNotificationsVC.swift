//
//  AcceptNotificationsVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class AcceptNotificationsVC: UIViewController {

    var isRegisteredForLocalNotifications : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: notification, object: nil)
    }
   
    override func viewDidDisappear(_ animated: Bool) {
    
        NotificationCenter.default.removeObserver(self, name: notification, object: nil)
    }
    
    func refreshView()
    {
        isRegisteredForLocalNotifications = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
        if(isRegisteredForLocalNotifications == true)
        {
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "campus") as! CampusSelectionVC
            UserDefaults.standard.set(true, forKey:"Login")
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextCLick(_ sender: UIButton)
    {
        showSettingAlert()
    }
    
    func showSettingAlert()
    {
        // Create the alert controller
        let alertController = UIAlertController(title: "Notification Services Disabled!", message: "Enabling your Notifications allows you to receive important updates", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Allow Notifications", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else
            {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl)
            {
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.open(settingsUrl, completionHandler:
                        {
                            (success) in
                           
                            print("Settings opened: \(success)") // Prints true
                            
                        })
                }
                else
                {
                    UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Keep Disabled", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            let obj = self.storyboard?.instantiateViewController(withIdentifier: "campus") as! CampusSelectionVC
            UserDefaults.standard.set(true, forKey:"Login")
            self.navigationController?.pushViewController(obj, animated: true)
        }
        
        // Add the actions
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
