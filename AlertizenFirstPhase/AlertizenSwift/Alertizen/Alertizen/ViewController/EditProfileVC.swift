//
//  EditProfileVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var items: [String] = ["Your Profile","Advanced"]
    
    var TitleLabelArray : [String] = ["Tap To Update","Full name","Phone","Password","Email"]
    
    var DetailLabelrray : [String] = []
    
    var finalUserNm:String! = nil

    var fullNameStr: String! = nil
    
    var errorStr:String! = nil
    
    var LogoutSectionLblArray : [String] = ["Log Out","Delete Account"]
    
    var imagesArray : [String] = ["logout_icon","deleteAccount_icon"]
    
    @IBOutlet weak var editProfileTableView: UITableView!
    
    var imagePicker: UIImagePickerController!
    
    var profileImage = UIImageView()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        editProfileTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            fname = ((detail["userDetails"] as! NSDictionary)["fname"] as! String)
            
            phone = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            lname = ((detail["userDetails"] as! NSDictionary)["lname"] as! String)
        
            //username = ((detail["userDetails"] as! NSDictionary)["username"] as! String)

            emailKey = ((detail["userDetails"] as! NSDictionary)["email"] as! String)
        
            userId = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)

            fullNameStr = String(format: "%@ %@",fname , lname)
        
            if (UserDefaults.standard.bool(forKey: "Facebook") == true)
            {
                let firstChar = String(fname.characters.first!)
                
                if !phone.isEmpty {
                    
                    let phoneLast4Char =  phone.substring(from:phone.index(phone.endIndex, offsetBy: -4))
                    
                    finalUserNm = String(format:"%@%@%@",firstChar,lname,phoneLast4Char)
                    
                    DetailLabelrray = ["",fullNameStr,finalUserNm,phone,"",""]
                }
                else {
                    
                    finalUserNm = String(format:"%@%@",firstChar,lname)
                    
                    DetailLabelrray = ["",fullNameStr,"","",""]
                }
            }
            else
            {
                DetailLabelrray = ["",fullNameStr,phone,"........",emailKey]
            }
            editProfileTableView.delegate = self
            editProfileTableView.dataSource = self
            editProfileTableView.reloadData()
 
    }
    
  
    
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 30))
        
        let title = UILabel(frame: CGRect(x: 15, y:0, width: self.view.frame.size.width-30, height: 30))
        header.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 77/255.0, blue: 61/255.0, alpha: 1)
        
        title.textColor = UIColor.lightGray
        title.text = self.items[section]
        title.font = UIFont(name: "Bell MT", size: 18)!
        
        if (section == 0)
        {
            title.textColor = UIColor.white
            title.textAlignment = .center
        }
        else
        {
            title.textColor = UIColor.black
        }
        
        
        header.addSubview(title)
        return header
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.items.count
    }
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            return TitleLabelArray.count
        }
        else
        {
            return LogoutSectionLblArray.count;
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                return 45
            }
            else
            {
                return 55
            }
        }
        else
        {
            return 55
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cellIdentifier = "Cell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            
            if cell == nil
            {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: nil)
            }

            if(indexPath.row == 0)
            {
                let btnToAddProfile = UIButton()
                if (UserDefaults.standard.bool(forKey: "Facebook") != true)
                {
                    btnToAddProfile.frame = CGRect(x:52,y:1,width:(cell?.frame.size.width)!-40,height:(cell?.frame.size.height)!)
                    btnToAddProfile.setTitle(self.TitleLabelArray[indexPath.row], for:.normal)
                    btnToAddProfile.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(15.0))
                    btnToAddProfile.setTitleColor(UIColor.black, for: UIControlState.normal)
                    btnToAddProfile.contentHorizontalAlignment = .left
                    btnToAddProfile.addTarget(self, action: #selector(btnToAddProfileClick), for: .touchUpInside)
                    cell?.addSubview(btnToAddProfile)
                }
                
                profileImage.frame = CGRect(x:15,y:7,width:30,height:30)
                if PhotoUrl != ""
                {
                    profileImage.sd_setImage(with: URL(string: PhotoUrl), placeholderImage:
                        UIImage(named: "imageEdit_icon"))
                }
                else
                {
                    profileImage.image = UIImage.init(named: "imageEdit_icon")
                    btnToAddProfile.setTitle("Tap To Add", for:.normal)
                }
                profileImage.contentMode = UIViewContentMode.scaleAspectFit
                cell?.addSubview(profileImage)
            }
            
            else
            {
                cell?.textLabel?.font = UIFont(name: "Bell MT Std", size: 19)!
                cell?.textLabel?.text = self.TitleLabelArray[indexPath.row]
                cell?.textLabel?.textColor = UIColor.black
                
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: CGFloat(13.0))
                cell?.detailTextLabel?.text = self.DetailLabelrray[indexPath.row]
                cell?.detailTextLabel?.textColor = UIColor .black
            }
            cell?.selectionStyle = .none
            if (UserDefaults.standard.bool(forKey: "Facebook") != true)
            {
                let chevron = UIImage(named: "rightArrowDouble_icon")
                cell?.accessoryType = .disclosureIndicator
                cell?.accessoryView = UIImageView(image: chevron!)
            }
            return cell!
        }
        else
        {
            var cell:CustomTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CustomTableViewCell
            
            cell?.selectionStyle = .none
            
            if  (cell==nil)
            {
                let nib:NSArray=Bundle.main.loadNibNamed("CustomTableViewCell", owner: self, options: nil)! as NSArray
                cell = nib.object(at: 0)as? CustomTableViewCell
            }
            
            cell.profileImageView.image = UIImage(named: imagesArray[indexPath.row])
            
            cell?.profileTitleLabel?.font = UIFont.systemFont(ofSize: CGFloat(18.0))

            if indexPath.row == 1
            {
                cell.profileTitleLabel.textColor = UIColor.red
            }
            else
            {
                cell.profileTitleLabel.textColor = UIColor.black
            }
            
            cell.profileTitleLabel.text = LogoutSectionLblArray[indexPath.row]
            
            cell.profileDoubleArrowIcon.isHidden = true
    
            return cell

        }
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.section == 0
        {
            if (UserDefaults.standard.bool(forKey: "Facebook") != true)
            {
            switch indexPath.row {
           /* case 1:
                let vc = EditFullNameViewController(nibName: "EditFullNameViewController", bundle: nil)
                vc.titleLabelText = "Full Name"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            case 2:
                let vc = EditFullNameViewController(nibName: "EditFullNameViewController", bundle: nil)
                vc.titleLabelText = "UserName"

                self.navigationController?.pushViewController(vc, animated: true)*/
                
            case 3:
                let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "EditPhoneNumberVC") as! EditPhoneNumberVC
                self.navigationController?.pushViewController(editProfile, animated: true)
            case 4:
                let vc = EditFullNameViewController(nibName: "EditFullNameViewController", bundle: nil)
                vc.titleLabelText = "Password"
                
                self.navigationController?.pushViewController(vc, animated: true)
            case 5:
                let vc = EditFullNameViewController(nibName: "EditFullNameViewController", bundle: nil)
                vc.titleLabelText = "Email"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            default:
                print(indexPath.row)

            }
          }
        }
        else
        {
            switch indexPath.row
            {
            case 0:
                
                UserDefaults.standard.set(nil, forKey:"monitoringAreaKey")
                UserDefaults.standard.set(nil, forKey:"onOffArray")
                UserDefaults.standard.set(false, forKey:"Login")
                UserDefaults.standard.set(false, forKey:"mobileMontOn")
                
                let alertController = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
                //Cancel Button
                let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.default)
                { (result : UIAlertAction) -> Void in
                    
                }
                alertController.addAction(cancelAction)
                
                //Ok Button
                let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default)
                { (result : UIAlertAction) -> Void in
                    
                    UserDefaults.standard.set(nil, forKey: "campusSelect")
                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! UserSignInVC
                   
                    obj.ComingFromLogout = true
                    self.navigationController?.pushViewController(obj, animated: false)

                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

            case 1:
                
                self.showAlert(msg:"Are you sure you want to delete account?")
           
            default:
               
                print(indexPath.row)
            }
        }
    }
    
    func deleteAccount()
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
            //phone
            let dictUserInfo = ["userId":userId, "phone":phone,"secure_token":"CMPS-EltDel00Rt"] as [String : String]
            print(dictUserInfo)
            WebService.sharedInstance.postMethodWithParams(strURL: "delete.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                            {
                                hud.removeFromSuperview()
                                print(dictReponse)
                                self.view.isUserInteractionEnabled = true
                                
                                UserDefaults.standard.set(false, forKey:"Login")
                                
                                UserDefaults.standard.set(false, forKey:"Scheduled")
                                
                                UserDefaults.standard.set(false, forKey:"mobileMontOn")
                                
                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "authentication") as! AuthenticationVC
                                self.navigationController?.pushViewController(obj, animated: false)
                            }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        
                        OperationQueue.main.addOperation
                        {
                            hud.removeFromSuperview()
                            self.view.isUserInteractionEnabled = true
                            UIAlertController.Alert(title: "", msg: self.errorStr, vc: self)
                        }
                        
                    }
                    
            }, failure:{ (errorMsg) in
               
            })
        }
    }
    
    func showAlert(msg:String) -> Void
    {
        let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        //Cancel Button
        let cancelAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(cancelAction)
        
        //Ok Button
        let okAction = UIAlertAction(title: "YES", style: UIAlertActionStyle.default)
        { (result : UIAlertAction) -> Void in
            
             self.deleteAccount()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
   
    func btnToAddProfileClick(_ sender: UIButton)
    {
        if (UserDefaults.standard.bool(forKey: "Facebook") != true)
        {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let actionTake = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.showCamera(mediaType: "camera")
            })
            let actionSelect = UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) in
                //            self.showPhotoLibrary()
                self.showCamera(mediaType: "gallery")
            })
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                //            self.showPhotoLibrary()
                
            })
            //actionSheet.view.tintColor = Constant.UI.COLOR_black
            actionSheet.addAction(actionTake)
            actionSheet.addAction(actionSelect)
            actionSheet.addAction(actionCancel)
            self.present(actionSheet, animated: true, completion: nil)
        }
    
    }
    func showCamera(mediaType: String)
    {
        self.imagePicker = UIImagePickerController()
        if mediaType == "camera"
        {
            imagePicker.sourceType = .camera
            imagePicker.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.black
            ]
        }
        else
        {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.delegate = self
        imagePicker.navigationBar.setBackgroundImage(UIImage(), for: .default)
        imagePicker.navigationBar.shadowImage = UIImage()
        imagePicker.navigationBar.isTranslucent = true
        imagePicker.navigationBar.tintColor = UIColor.black
        self.present(imagePicker, animated: true, completion: nil)
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
        updateProfilePhoto()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func updateProfilePhoto() -> Void
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
            
            let scaledImage: UIImage? = self.scaledImage((profileImage.image)!)
           
            let imageData: NSData? = UIImagePNGRepresentation(scaledImage!) as NSData?
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let userID = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let strFileName = String(format: "%@photo.jpg", phnNo)
            
            let dictUserInfo = ["userid":userID,"filename":strFileName,"binary_file":imageData!.base64EncodedString(options: .lineLength64Characters),"secure_token":"CMPS-PhoUptoteda!87"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "update_photo.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                        {
                            
                            let   temp_Dict = NSMutableDictionary()

                            temp_Dict.addEntries(from: detail as! [AnyHashable : Any])
                            
                            print(temp_Dict)
                            
                            PhotoUrl = dictReponse.object(forKey: "photo_url") as? String
                            
                            temp_Dict.setValue(PhotoUrl, forKey: "file_http_url")
                            
                            print(temp_Dict)
                            
                            alertizenUser.userData(dic: temp_Dict)
                            
                            self.view.isUserInteractionEnabled = true
                            
                            hud.removeFromSuperview()
                            
                            let _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                        else
                        {
                            self.view.isUserInteractionEnabled = true
                            UIAlertController.Alert(title: "", msg: dictReponse.object(forKey: "error") as! String, vc: self)
                            hud.removeFromSuperview()
                        }
                    
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true

                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                
                hud.removeFromSuperview()
            })
            
        }
    }
    func scaledImage(_ image: UIImage) -> UIImage {
        let destinationSize = CGSize(width: CGFloat((self.profileImage.frame.size.width)), height: CGFloat((self.profileImage.frame.size.height)))
        UIGraphicsBeginImageContext(destinationSize)
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(destinationSize.width), height: CGFloat(destinationSize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    @IBAction func btnInbOXClick(_ sender: UIButton) -> Void {
        
        let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
        self.navigationController?.pushViewController(editProfile, animated: false)
        
    }
}
