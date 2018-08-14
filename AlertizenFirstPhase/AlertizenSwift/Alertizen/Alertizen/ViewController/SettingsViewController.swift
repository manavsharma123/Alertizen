//
//  SettingsViewController.swift
//  Alertizen
//
//  Created by MR on 24/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
 
    var items: [String] = ["Tell a Friend","Terms & Conditions" ,"Privacy Policy" , "About","Do Not Disturb","Activate Location","Activate Notifications","Manage Alerts"];
    
    var SettingImages: [String] = ["tellAFriend","settingsTerms_icon", "settingsPrivacy_icon","settingsAbout_icon","dnd-icon.png","settingsAbout_icon","dnd-icon.png","dnd-icon.png"];
    
    @IBOutlet weak var settingsTableViewObj: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        settingsTableViewObj.tableFooterView = UIView()
           // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: 30))
        
        let title = UILabel(frame: CGRect(x: 10, y:0, width: self.view.frame.size.width - 20, height: 30))
        
        header.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 77/255.0, blue: 61/255.0, alpha: 1)
        
//        header.backgroundColor = UIColor.blue
        
        title.font = UIFont(name: "Bell MT", size: 19)!
        title.textAlignment = .center
        title.textColor = UIColor.lightGray
        title.text = "Settings"
        title.textColor = UIColor.white
        header .addSubview(title)
        return header
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CustomTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell
        
        cell?.selectionStyle = .none
        
        if  (cell==nil)
        {
            let nib:NSArray=Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)! as NSArray
            cell = nib.object(at: 0)as? CustomTableViewCell
        }
        
        cell.profileImageView.image = UIImage(named: SettingImages[indexPath.row])
        cell?.profileTitleLabel?.text = self.items[indexPath.row]
        cell.profileDoubleArrowIcon.isHidden = true
        cell?.profileTitleLabel?.font = UIFont(name: "Bell MT Std", size: 19)!
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
            case 0:
                
                let vc = ShareVC(nibName: "ShareVC", bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)

            case 1:
                
            let vc = TermAndCondViewController(nibName: "TermAndCondViewController", bundle: nil)
             vc.titleLabelText = "TERMS & CONDITIONS"
            self.navigationController?.pushViewController(vc, animated: true)
            
            case 2:
               
                let vc = TermAndCondViewController(nibName: "TermAndCondViewController", bundle: nil)
                vc.titleLabelText = "Privacy Policy"
                self.navigationController?.pushViewController(vc, animated: true)
            
            case 3:
                
                let vc = AboutVC(nibName: "AboutVC", bundle: nil)
                
                self.navigationController?.pushViewController(vc, animated: true)
            
            case 4:
            
                let vc = DoNotDisturbViewController(nibName: "DoNotDisturbViewController", bundle: nil)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
        case 7:
            
            let vc = DontDistrubViewController(nibName: "DontDistrubViewController", bundle: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            
            print(indexPath.row)
            
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnInboxClick(_ sender: UIButton) -> Void {
        
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
      let editProfile = storyboard.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
      self.navigationController?.pushViewController(editProfile, animated: false)
        
    }
   
}
