//
//  CampusSelectionVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import AirshipKit
import GoogleMobileAds

class CampusSelectionVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    var arrDeleteMsg = [String]()
    
    @IBOutlet var tblCampus: UITableView!
    
    var arrayCampus = [Dictionary<String,AnyObject>]()
    
    var errorStr:String! = nil
   
    var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        self.navigationController?.navigationBar.isHidden = true
        
        if let historyWords = UserDefaults.standard.value(forKey: "campusSelect")as? [String] {
            
            self.arrDeleteMsg = historyWords
            
            //Abhi
            self.updateTagsOnUrbanAirship()
        }
         getCampusDetail()
    }
    
    func getCampusDetail() -> Void
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
           
            let udid = UserDefaults.standard.value(forKey: "UID")
            
         let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
       //     let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let phone = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
//            print(detail)
            
            let dictUserInfo = ["secure_token":"CMPS-CamllA80!55","device_id":udid!,"phone":phone,"and_channel_id":channelId as Any] as! [String : String]
            
            print(dictUserInfo)

            WebService.sharedInstance.postMethodWithParams(strURL: "get_all_campus.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    OperationQueue.main.addOperation
                    {
                        self.view.isUserInteractionEnabled = true
                        
                        self.arrayCampus = dictReponse.value(forKey: "campuses") as! [Dictionary<String, AnyObject>]
                        
                        self.tblCampus.delegate = self
                        self.tblCampus.dataSource = self
                        self.tblCampus.reloadData()
                        hud.removeFromSuperview()
                        
                    }
                    
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true
                
                hud.removeFromSuperview()
                
                self.showAlertAPIError(strTitle: "getCampus")
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 25
    }

    // Make the background color show through
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CampusTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CampusTableViewCell
        
        if  (cell==nil)
        {
            let nib:NSArray=Bundle.main.loadNibNamed("CampusTableViewCell", owner: self, options: nil)! as NSArray
            cell = nib.object(at: 0)as? CampusTableViewCell
        }
        
        cell?.selectionStyle = .none
        
        cell.layer.borderColor = UIColor.init(colorLiteralRed: 231/255.0, green: 77/255.0, blue: 61/255.0, alpha: 1).cgColor
        
        cell.layer.borderWidth = 1
        
        cell.backgroundColor = UIColor(red: 231.0/255.0, green: 77.0/255.0, blue: 61.0/255.0, alpha: 0.70)
        /*if(indexPath.section == 4)
        {
            cell.lblTitle.text = "See it? Hear it? Report it!"
            
            cell.lblTitle.textColor = UIColor.black
            
            if IS_IPHONE_5
            {
                cell.lblTitle.font = UIFont(name: "BellMT", size: 19)
            }
            cell?.accessoryType = .disclosureIndicator
            
            cell.btnCheckbox.isHidden = true
            //(112,181,255)
            cell.backgroundColor = UIColor(red: 112/255.0, green: 181/255.0, blue: 255.0/255.0, alpha: 0.70)
            
            cell.layer.borderColor = UIColor.init(red: 112/255.0, green: 181/255.0, blue: 255.0/255.0, alpha: 0.70).cgColor
        }*/
        
        if(indexPath.section == 3)
        {
            cell.lblTitle.text = "Off Campus Location"
            
            cell?.accessoryType = .disclosureIndicator
            
            cell.btnCheckbox.isHidden = true
        }
        else
        {
            let titleName = arrayCampus[indexPath.section]["name"] as! String
            
            cell.lblTitle.text = titleName
            
            cell.btnCheckbox.isHidden = false
            
            if let strID = arrayCampus[indexPath.section]["id"] as? String
            {
                cell.btnCheckbox.tag = Int(strID)!
            }
            else
            {
                cell.btnCheckbox.tag = arrayCampus[indexPath.section]["id"] as! Int
            }
          
            cell.btnCheckbox.addTarget(self, action: #selector(self.btnMessageCheckBoxPressed), for: .touchUpInside)
            
            if let historyWords =  UserDefaults.standard.value(forKey: "campusSelect")as? [String]
            {
                self.arrDeleteMsg = historyWords
            }
       
            if arrDeleteMsg.contains(String(cell.btnCheckbox.tag))
            {
                cell.btnCheckbox.setImage(UIImage(named: "campusCheckedBtn_icon"), for: .normal)
            }
            else
            {
                cell.btnCheckbox.setImage(UIImage(named: "campusUncheckedBtn_icon"), for: .normal)
            }
        }
        return cell!
    }
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (indexPath.section == 3)
        {
            if let historyWords =  UserDefaults.standard.value(forKey: "campusSelect")as? [String]
            {
              print(historyWords)
                let vc = AreaMonitoringVC(nibName: "AreaMonitoringVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else
            {
                UIAlertController.Alert(title: "Error", msg: "Please select Campus!", vc: self)
            }
        }
        
        /*if (indexPath.section == 4)
        {
            if let historyWords =  UserDefaults.standard.value(forKey: "campusSelect")as? [String]
            {
                let vc = ReportActivityViewController(nibName: "ReportActivityViewController", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            else
            {
                UIAlertController.Alert(title: "Error", msg: "Please select Campus!", vc: self)
            }
            
        }*/
    }
    
    func checkCampusSelected() -> Void {
        
        if let historyWords =  UserDefaults.standard.value(forKey: "campusSelect")as? [String]
        {
            print(historyWords)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InboxVC")
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        else
        {
            UIAlertController.Alert(title: "Error", msg: "Please select Campus!", vc: self)
        }
    }
    @IBAction func btnProfilePressed(_ sender: UIButton)
    {
        if let historyWords =  UserDefaults.standard.value(forKey: "campusSelect")as? [String]
        {
            print(historyWords)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC")
            self.navigationController?.pushViewController(vc!, animated: false)
            
        }
        else
        {
            UIAlertController.Alert(title: "Error", msg: "Please select Campus!", vc: self)
        }
        
        
    }
    @IBAction func btnMNextPressed(_ sender: UIButton)
    {
        self.checkCampusSelected()
    }
    
    @IBAction func btnMInboxPressed(_ sender: UIButton)
    {
       self.checkCampusSelected()
    }
    
    func btnMessageCheckBoxPressed(_ sender: UIButton)
    {
        let index = sender.tag
        if arrDeleteMsg.contains(String(index))
        {
            let getIndex =  arrDeleteMsg.index(where: { $0 == String(index) })
            
            arrDeleteMsg.remove(at: getIndex!)
            
            sender.setImage(UIImage(named: "campusUncheckedBtn_icon"), for: .normal)
        }
        else
        {
            arrDeleteMsg.append(String(index))
            sender.setImage(UIImage(named: "campusCheckedBtn_icon"), for: .normal)
        }
        selectCampusRequest()
    }
    
    func selectCampusRequest() -> Void
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
            
            let userID = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let str = arrDeleteMsg.joined(separator: ",")
          
            let phone = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
          
            let udid = UserDefaults.standard.value(forKey: "UID")
       
            let dictUserInfo = ["userId":userID,"selectCampusesIds":str,"secure_token":"CMPS-SelCam0089T","device_id": udid!,"phone": phone,"and_channel_id":channelId as Any] as! [String : String]
            
           print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "select_campus.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                        {
                            self.updateTagsOnUrbanAirship()
                            UserDefaults.standard.set(self.arrDeleteMsg, forKey: "campusSelect")
                            self.view.isUserInteractionEnabled = true
                            hud.removeFromSuperview()
                        }
                    }
                    
                    else
                    {
                       self.updateTagsOnUrbanAirship()
                       
                        UserDefaults.standard.set(nil, forKey: "campusSelect")
                            
                         self.view.isUserInteractionEnabled = true
                            
                        UIAlertController.Alert(title: "Error", msg: dictReponse.object(forKey: "error") as! String, vc: self)
                    }
                    
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true
                
                hud.removeFromSuperview()
                
                self.showAlertAPIError(strTitle: "selectCampus")
            })
        }
    }
    
    func updateTagsOnUrbanAirship() -> Void
    {
        UAirship.push().tags = self.arrDeleteMsg
        UAirship.push().updateRegistration()
    }
    
    //MARK:- Alert
    func showAlertAPIError(strTitle: String) {
        
        let alertController = UIAlertController(title: "API Error", message: "There seems to be a problem in fetching the data at the moment. Please try again. ", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            
            UIAlertAction in
            
            if strTitle == "getCampus" {
                
                self.getCampusDetail()
            }
            else {
                
                self.selectCampusRequest()
            }
        }
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
