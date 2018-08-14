//
//  ProfileVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items: [String] = ["Profile","Settings"]
    
    var imagesArray : [String] = ["tabProfileSelected_icon","menuSettings_icon"]
    
    @IBOutlet weak var profileTableViewObj: UITableView!
    
    @IBOutlet weak var userNmTxtFld:UITextField!

    @IBOutlet weak var userNameView: UIView!
   
    @IBOutlet var profileImage: UIImageView?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        profileTableViewObj.register(UINib(nibName:"CustomTableViewCell", bundle: nil), forCellReuseIdentifier:"Cell")
        
        profileTableViewObj.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
        let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
        
        fname = ((detail["userDetails"] as! NSDictionary)["fname"] as! String)

        lname = ((detail["userDetails"] as! NSDictionary)["lname"] as! String)
        
        phone = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)

        OperationQueue.main.addOperation
            {
                SDImageCache.shared().clearMemory()
               
                SDImageCache.shared().clearDisk()

                if (UserDefaults.standard.bool(forKey: "Facebook") == true)
                {
                    PhotoUrl = String(format: "https:graph.facebook.com/%@/picture?type=large", detail_Dict)
                }
                else
                {
                    if let photoUrl = ((detail["userDetails"] as! NSDictionary)["photo"] as? String)
                    {
                        PhotoUrl = photoUrl
                    }
                    if let photo = (UserDefaults.standard.value(forKey: "PhotoUrl")as? String)
                    {
                        PhotoUrl = photo
                    }
                }
                if PhotoUrl != ""
                {
                    self.profileImage?.sd_setImage(with: URL(string: PhotoUrl), placeholderImage:
                        UIImage(named: "profileDefaultImage"))
                }
                
                self.profileImage?.layer.cornerRadius = (self.profileImage?.frame.size.height)!/2
                
                self.profileImage?.layer.masksToBounds = true
                
                self.profileImage?.layer.borderWidth = 2
                
                self.profileImage?.layer.borderColor = UIColor.white.cgColor
                
                if (UserDefaults.standard.bool(forKey: "Facebook") == true)
                {
                    let firstChar = String(fname.characters.first!)
                    
                    if !phone.isEmpty {
                        
                        let phoneLast4Char =  phone.substring(from:phone.index(phone.endIndex, offsetBy: -4))
                        
                        self.userNmTxtFld.text = String(format:"%@%@%@",firstChar,lname,phoneLast4Char)
                    }
                    else {
                        
                        self.userNmTxtFld.text = String(format:"%@%@",firstChar,lname)
                    }
                }
                else
                {
                    self.userNmTxtFld.text = ((detail["userDetails"] as! NSDictionary)["email"] as! String)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let vcIndex = self.navigationController?.viewControllers.index(where: { (viewController) -> Bool in
            
            if let _ = viewController as? CampusSelectionVC {
                return true
            }
            return false
        })
        
        let composeVC = self.navigationController?.viewControllers[vcIndex!] as! CampusSelectionVC
        
        let _ =  self.navigationController?.popToViewController(composeVC, animated: true)
        
    }
    
    @IBAction func userNameBtnClick(_ sender: UIButton)
    {
        let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(editProfile, animated: true)
    }
   
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return userNameView.frame.size.height
    }
    
    // Make the background color show through
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return userNameView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:CustomTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if  (cell==nil)
        {
            let nib:NSArray=Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)! as NSArray
            cell = nib.object(at: 0)as? CustomTableViewCell
        }
        
        cell.profileImageView.image = UIImage(named: imagesArray[indexPath.row])
        cell.profileTitleLabel.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 0 {
            let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(editProfile, animated: true)
        }
        else
        {
            let vc = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnInboxClick(_ sender: Any)
    {
        let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
        self.navigationController?.pushViewController(editProfile, animated: false)
    }
}
