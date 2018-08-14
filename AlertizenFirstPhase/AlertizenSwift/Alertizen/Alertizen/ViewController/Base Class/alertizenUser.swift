//
//  alertizenUser.swift
//  Alertizen
//
//  Created by Manya on 01/12/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit


var emailKey:String!
var fname:String!
var lname:String!
var phone:String!
var userId:String!
//var username:String!
var checkFb:String!
var dnd:String!
var PhotoUrl:String!


class alertizenUser: NSObject
{
        
   class func userData(dic:NSDictionary)
   {
    
      print(dic)
    
      emailKey = ((dic["userDetails"] as! NSDictionary)["email"] as! String)
      fname = ((dic["userDetails"] as! NSDictionary)["fname"] as! String)
      lname = ((dic["userDetails"] as! NSDictionary)["lname"] as! String)
      phone = ((dic["userDetails"] as! NSDictionary)["phone"] as! String)
      userId = ((dic["userDetails"] as! NSDictionary)["userId"] as? String ?? "")
    //  username = ((dic["userDetails"] as! NSDictionary)["username"] as! String)
    
      if let photoUrl = (dic["file_http_url"] as? String)
      {
          PhotoUrl = photoUrl
        
          UserDefaults.standard.set(photoUrl, forKey: "PhotoUrl")
      }
      else
      {
          UserDefaults.standard.set(nil, forKey: "PhotoUrl")
      }
      if let photoUrl = ((dic["userDetails"] as! NSDictionary)["photo"] as? String)
      {
          PhotoUrl = photoUrl
      }
    
        if let dnd1 = ((dic["userDetails"] as! NSDictionary)["dnd_status"] as? String)
        {
            dnd = dnd1
        }
        else
        {
            dnd = "0"
            UserDefaults.standard.set("12:00 AM", forKey:"From")
            UserDefaults.standard.set("12:00 PM", forKey:"To")
        }
    
        if (dnd == "1")
        {
            let strFrom : String = ((dic["userDetails"] as! NSDictionary)["from_time"] as? String)!
            let strTo : String = ((dic["userDetails"] as! NSDictionary)["to_time"] as? String)!
            if strFrom != "" || strTo != ""
            {
                UserDefaults.standard.set(true, forKey:"dontDisturb")
                UserDefaults.standard.set(true, forKey:"Scheduled")
                UserDefaults.standard.set(strFrom, forKey:"From")
                UserDefaults.standard.set(strTo, forKey:"To")

            }
            else
            {
                UserDefaults.standard.set(true, forKey:"dontDisturb")
                UserDefaults.standard.set(false, forKey:"Scheduled")
            }
        }
        else
        {
            UserDefaults.standard.set(false, forKey:"dontDisturb")
            UserDefaults.standard.set(false, forKey:"Scheduled")
            UserDefaults.standard.set("12:00 AM", forKey:"From")
            UserDefaults.standard.set("12:00 PM", forKey:"To")
        }
    
        if let campusSelect = ((dic["userDetails"] as! NSDictionary)["campuses"] as? NSArray)
        {
            if campusSelect.count > 0 {
                
                let check = campusSelect[0] as! String
                
                if check == "" {
                    
                    UserDefaults.standard.set(nil, forKey: "campusSelect")
                }
                else {
                   
                    UserDefaults.standard.set(campusSelect, forKey: "campusSelect")
                }
            }
            else {
                
                UserDefaults.standard.set(nil, forKey: "campusSelect")
            }
        }
    
        if let lastAlert = ((dic["userDetails"] as! NSDictionary)["last_alert_time"] as? String)
        {
            print(lastAlert)
            UserDefaults.standard.set(dic, forKey:"getUserDetails")
        }
        else
        {
            let   userDetails_Dict1 =  NSMutableDictionary()

            let   temp_Dict1 = NSMutableDictionary()
            
            let  detail_Dict = dic["userDetails"] as! NSDictionary
            
            temp_Dict1.addEntries(from: detail_Dict as! [AnyHashable : Any])
            
            temp_Dict1.setValue("", forKey: "last_alert_time")
            
            userDetails_Dict1.setValue(temp_Dict1, forKey: "userDetails")
            
            print(temp_Dict1)
            
            UserDefaults.standard.set(userDetails_Dict1, forKey: "getUserDetails")
           
        }
    
    let dicdefault = ["key":"1"]
    UserDefaults.standard.set(dicdefault, forKey:"getMapInfoDetails")
    ///
    let dicdefault1 = ["key":"1"]
    UserDefaults.standard.set(dicdefault1, forKey:"getMapUpdateDetails")
    UserDefaults.standard.set("3", forKey:"switchSet")
    UserDefaults.standard.set("3", forKey:"UpdateswitchSet")
    
    UserDefaults.standard.set("0", forKey: "phoneVerify")
     UserDefaults.standard.set("0", forKey: "codeentered")
   }

}
