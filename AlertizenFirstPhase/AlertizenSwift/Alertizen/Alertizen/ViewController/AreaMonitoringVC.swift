//
//  AreaMonitoringVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 21/01/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit

var dictMonitoring = Dictionary<String, Any>()

class AreaMonitoringVC: UIViewController,UITableViewDelegate,UITableViewDataSource
 {
    @IBOutlet var tblCampus: UITableView!
    
    var dictMonitoringArea = Dictionary<String, Any>()
    
    var errorStr:String! = nil
    
    var checkSelection = Int()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        checkSelection = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.calledApiList()
    }
    
    func calledApiList() -> Void {
      
        if checkSelection == 4 {
            
            let detail : NSString = UserDefaults.standard.value(forKey:"switchSet") as! NSString
            if detail != "3"
            {
                let Checkdetail : NSString = UserDefaults.standard.value(forKey:"UpdateswitchSet") as! NSString
                if detail == Checkdetail
                {
                    getMonitoringList()
                }
            }
        }
        else
        {
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getMapInfoDetails") as! NSDictionary
            if detail.count == 1
            {
                getMonitoringList()
            }
            else
            {
                dictMonitoringArea = dictMonitoring
                self.tblCampus.delegate = self
                self.tblCampus.dataSource = self
                self.tblCampus.reloadData()
                let updateDic : NSDictionary = UserDefaults.standard.value(forKey:"getMapUpdateDetails") as! NSDictionary
                if updateDic.count != 1
                {
                    let address = detail.value(forKey: "address") as! NSString
                    let area_name = detail.value(forKey: "area_name") as! NSString
                    let latitude = detail.value(forKey: "latitude") as! NSString
                    //let longitude = detail.value(forKey: "longitude")
                    let status = detail.value(forKey: "status")as! NSString
                    let distance = detail.value(forKey: "distance")as! NSString
                    
                    
                    let addressUpdate = updateDic.value(forKey: "address") as! NSString
                    let area_nameUpdate = updateDic.value(forKey: "mon_name")as! NSString
                    //let latitudeUpdate = updateDic.value(forKey: "latitude") as! NSString
                    let latUpdate = updateDic.value(forKey: "latitude")
                    var latitudeUpdate = NSString()
                    latitudeUpdate = String(describing: latUpdate!) as NSString!
                    //let longitudeUpdate = updateDic.value(forKey: "longitude")
                    let statusUpdate = updateDic.value(forKey: "status")as! NSString
                    let distanceUpdate = updateDic.value(forKey: "distance")as! NSString
                    
                    if address != addressUpdate
                    {
                        getMonitoringList()
                    }
                    if area_name != area_nameUpdate
                    {
                        getMonitoringList()
                    }
                    if latitudeUpdate != latitude
                    {
                        getMonitoringList()
                    }
                    
                    if status != statusUpdate
                    {
                        getMonitoringList()
                    }
                    if distance != distanceUpdate
                    {
                        getMonitoringList()
                    }
 
                }
            }

        }
       
    }
    
    
    func getMonitoringList() -> Void
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
            
            self.view.isUserInteractionEnabled = false
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let userID = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let dictUserInfo = ["userId":userID,"phone":phnNo,"device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-getM4566jkAr"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "get_mon_area.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                
                { (dictReponse) in
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                            {
                                self.view.isUserInteractionEnabled = true
                                self.dictMonitoringArea = dictReponse.value(forKey: "monitoring_area") as! Dictionary
                                dictMonitoring = dictReponse.value(forKey: "monitoring_area") as! Dictionary
                                
                                self.tblCampus.delegate = self
                                self.tblCampus.dataSource = self
                                self.tblCampus.reloadData()
                                hud.removeFromSuperview()
                                
                                var dic = NSDictionary()
                                dic = self.dictMonitoringArea as NSDictionary
                                print(dic)
                                UserDefaults.standard.set(dic.value(forKey: "area_1"), forKey:"getMapInfoDetails")
                                
                            }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        UIAlertController.Alert(title: "", msg: self.errorStr, vc: self)
                        self.view.isUserInteractionEnabled = true
                        hud.removeFromSuperview()
                    }
                    
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true

                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)

                hud.removeFromSuperview()
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return dictMonitoringArea.count
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0 || section == 3)
        {
            return 1
        }
        else
        {
            return 0
        }
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0 || section == 3)
        {
            return 25
        }
        else
        {
            return 0
        }
    }
    
    // Make the background color show through
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.`default`, reuseIdentifier: nil)
        }
        
        cell?.textLabel?.font = UIFont(name: "Bell MT", size: 20)!
        
        cell?.backgroundColor = UIColor.init(colorLiteralRed: 253/255.0, green: 129/255.0, blue: 122/255.0, alpha: 1)
        
        cell?.selectionStyle = .none
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        //ON OFF Button
        let button = UIButton(frame: CGRect(x: tableView.frame.size.width - 60, y: 10, width: 30, height: 30))
        
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.addTarget(self, action: #selector(AreaMonitoringVC.onOffButton), for: .touchUpInside)
        
        cell?.addSubview(button)
        
        if indexPath.section == 0
        {
            
            let dictArea = self.dictMonitoringArea["area_1"] as! [String: AnyObject]
            
            let areaName = dictArea["area_name"] as! String
            
            cell?.textLabel?.text = areaName
            
            let status = dictArea["status"] as! String
            
            if (status == "1")
            {
                button.setTitle("On", for: .normal)
            }
            else
            {
                button.setTitle("Off", for: .normal)
            }
            
        }
        else if indexPath.section == 3
        {
            cell?.textLabel?.text = "Mobile Monitoring"
            let dictArea = self.dictMonitoringArea["mobile_area"] as! [String: AnyObject]
            let status = dictArea["status"] as! String
            if (status == "1")
            {
                button.setTitle("On", for: .normal)
                
                if let strLat = dictArea["latitude"] as? String, let strLongi = dictArea["longitude"] as? String
                {
                    UserDefaults.standard.set(Double(strLat), forKey:"latitudeOld")
                    UserDefaults.standard.set(Double(strLongi), forKey:"longitudeOld")
                }
                UserDefaults.standard.set(true, forKey:"mobileMontOn")
            }
            else
            {
                button.setTitle("Off", for: .normal)
                UserDefaults.standard.set(false, forKey:"mobileMontOn")
            }
        }
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = MapViewController(nibName: "MapViewController", bundle: nil)
        if indexPath.section == 0
        {
            vc.siwtchTag = 1
            checkSelection = 1
        }
        else
        {
            checkSelection = 4
            vc.siwtchTag = 4
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func onOffButton()
    {
        
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) -> Void {
        
        let _ = self.navigationController?.popViewController(animated: true)

    }

}
