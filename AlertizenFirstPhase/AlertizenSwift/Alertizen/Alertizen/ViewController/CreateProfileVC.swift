//
//  CreateProfileVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import CoreData
import AirshipKit

class CreateProfileVC: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var imagePicker: UIImagePickerController!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtLastName: UITextField!
    @IBOutlet var txtEmailAddress: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var svMainProfile: UIScrollView!
    @IBOutlet var profileImage: UIImageView?
    @IBOutlet var addPhotoButton: UIButton?
    @IBOutlet var btnNxt: UIButton?
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    
    var successStr:String! = nil
    var phoneStr:String! = nil
    var errorStr:String! = nil
    
    var userDetails:NSDictionary!
    
    var isRegisteredForLocalNotifications : Bool!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
      //  let gesture = UITapGestureRecognizer()
        
//  gesture.addTarget(self, action: )
        
        self.navigationController?.isNavigationBarHidden = true
        
        profileImage?.layer.cornerRadius = (profileImage?.frame.height)!/2
        profileImage?.layer.borderWidth = 2.0
        profileImage?.layer.borderColor = UIColor(red: 231.0/255.0, green: 77.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
        profileImage?.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        
        let bounds = UIScreen.main.bounds
        
        let height = bounds.size.height
        
        switch height
        {
            case 568.0:
                svMainProfile.contentSize = CGSize(width: self.view.frame.size.width, height: svMainProfile.frame.height+140)
            case 667.0:
                svMainProfile.contentSize = CGSize(width: self.view.frame.size.width, height: svMainProfile.frame.height+160)
            case 736.0:
                svMainProfile.contentSize = CGSize(width: self.view.frame.size.width, height: svMainProfile.frame.height+180)
            default:
                svMainProfile.contentSize = CGSize(width: self.view.frame.size.width, height: svMainProfile.frame.height+130)
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Tap Gesture
    func handleTap() -> Void
    {
        self.view.endEditing(true)
        
//        txtFirstName.resignFirstResponder()
//        txtLastName.resignFirstResponder()
//        txtEmailAddress.resignFirstResponder()
//        txtPassword.resignFirstResponder()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) -> Void {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actionTake = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showCamera(mediaType: "camera")
        })
        let actionSelect = UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action) in
            self.showCamera(mediaType: "gallery")
        })
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("cancelled")
        })
        //actionSheet.view.tintColor = Constant.UI.COLOR_black
        actionSheet.addAction(actionTake)
        actionSheet.addAction(actionSelect)
        actionSheet.addAction(actionCancel)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func btnAlreadyMemberAction(_ sender: UIButton) {
      
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! UserSignInVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    
    func showCamera(mediaType: String) {
        self.imagePicker = UIImagePickerController()
        if mediaType == "camera" {
            imagePicker.sourceType = .camera
            imagePicker.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.black
            ]
        }
        else {
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
        profileImage?.image = image
        picker.dismiss(animated: true, completion: nil)
        //btnphoto
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)

    }

    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
         self.navigationController?.popViewController(animated: false)
    }
    
    
    // MARK :- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if((textField.text?.isEqual("First Name"))!||(textField.text?.isEqual("Last Name"))!||(textField.text?.isEqual("UserName"))!||(textField.text?.isEqual("Email Address"))! || (textField.text?.isEqual("Cell Phone"))!)
        {
            textField.text = ""
        }
        else if(textField.text? .isEqual("Password"))!
        {
            txtPassword.text = ""
            txtPassword.isSecureTextEntry = true
        }
        
        if textField == txtFirstName
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }
            
        else if(textField == txtLastName)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
        }
        else if(textField == txtPhoneNumber)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 300), animated: true)
        }
            
        else if(textField == txtEmailAddress)
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 340), animated: true)
        }
        else
        {
            svMainProfile.setContentOffset(CGPoint(x: 0, y: 390), animated: true)
        }
    }
    
    
    // 8 August
    @IBAction func textValueChanged(_ sender: UITextField)
    {
              checkMaxLength(textField: sender , maxLength: 9)
    }
    
    
    func checkMaxLength(textField: UITextField!, maxLength: Int)
    {
        if (textField.text!.count > maxLength)
        {
            
            txtEmailAddress.becomeFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(txtFirstName.text?.isEqual(""))! {
            txtFirstName.text = "First Name"
        }
        else if(txtLastName.text?.isEqual(""))! {
            txtLastName.text = "Last Name"
        }
            
            
//        else if(txtUserName.text?.isEqual(""))! {
//            txtUserName.text = "UserName"
//        }
        else if(txtEmailAddress.text?.isEqual(""))! {
            txtEmailAddress.text = "Email Address"
        }
            
        else if(txtPhoneNumber.text?.isEqual(""))! {
            txtPhoneNumber.text = "Cell Phone"
        }
        else if(txtPassword.text?.isEqual(""))! {
            txtPassword.text = "Password"
            txtPassword.isSecureTextEntry = false
        }
        svMainProfile.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName {
            txtPhoneNumber.becomeFirstResponder()
        }
//        else if textField == txtUserName{
//
//            txtPhoneNumber.becomeFirstResponder()
//        }
        
        else if textField == txtPhoneNumber{
            txtEmailAddress.becomeFirstResponder()
        }
        if textField == txtEmailAddress {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func scaledImage(_ image: UIImage) -> UIImage {
        let destinationSize = CGSize(width: CGFloat((self.profileImage?.frame.size.width)!), height: CGFloat((self.profileImage?.frame.size.height)!))
        UIGraphicsBeginImageContext(destinationSize)
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(destinationSize.width), height: CGFloat(destinationSize.height)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
   
    @IBAction func btnNextClick(_ sender: AnyObject)
    {
        isRegisteredForLocalNotifications = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false

        self.view.endEditing(true)
        
//        txtFirstName.resignFirstResponder()
//        txtLastName.resignFirstResponder()
//        txtUserName.resignFirstResponder()
//        txtEmailAddress.resignFirstResponder()
//        txtPassword.resignFirstResponder()
        
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            if(txtFirstName.text != "First Name") && (txtLastName.text != "Last Name") && (txtEmailAddress.text != "Email Address") && (txtPassword.text != "Password") && (txtPhoneNumber.text! != "Cell Phone")
        {
            //UIImageJPEGRepresentation
            hud.show(true)
           
            hud.frame = self.view.frame
            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
            hud.color = UIColor.clear
            self.view.addSubview(hud)
            let udid = UserDefaults.standard.value(forKey: "UID")
            self.view.isUserInteractionEnabled = false
            let scaledImage: UIImage? = self.scaledImage((profileImage?.image)!)
            let imageData: NSData? = UIImagePNGRepresentation(scaledImage!) as NSData?
           
            if channelId == nil {
                
                channelId = UAirship.push().channelID
            }
            //8 Aug
            let dictUserInfo = ["phone":txtPhoneNumber.text!,"first_name":txtFirstName.text!,"last_name":txtLastName.text!,"email":txtEmailAddress.text!,"password":txtPassword.text!,"filename":"photo.jpg","UU_ID":udid as? String,"binary_file":imageData!.base64EncodedString(options: .lineLength64Characters),"secure_token":"CMPS-Si00MNup3","and_channel_id":channelId] as! [String : String]
            
            print(dictUserInfo)
          
            WebService.sharedInstance.postMethodWithParams(strURL: "signup.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                   
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        alertizenUser.userData(dic: dictReponse)
                        OperationQueue.main.addOperation
                        {
                            UserDefaults.standard.set("1", forKey: "911_alert_1")
                            
                            UserDefaults.standard.set("1", forKey: "911_alert_2")
                            
                            UserDefaults.standard.set("1", forKey: "911_alert_3")
                            
                            UserDefaults.standard.synchronize()
                            
                            self.successStr = dictReponse.object(forKey: "success") as! String?
                            
                                self.view.isUserInteractionEnabled = true
                            
                                hud.removeFromSuperview()
                                
                                UserDefaults.standard.set(false, forKey:"Facebook")
                                
                                UserDefaults.standard.set(false, forKey:"Scheduled")
                               
                                if(self.isRegisteredForLocalNotifications == false)
                                {
                                    let obj = self.storyboard?.instantiateViewController(withIdentifier: "accept") as! AcceptNotificationsVC
                                    UserDefaults.standard.set(false, forKey:"Login")
                                    self.navigationController?.pushViewController(obj, animated: true)
                                }
                                else
                                {
                                    self.moveToNextClass()
                                }
                        }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        
                        OperationQueue.main.addOperation
                        {
                                self.view.isUserInteractionEnabled = true
                                hud.removeFromSuperview()
                                self.showAlert(msg:self.errorStr)
                        }
                    }
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true
               
                hud.removeFromSuperview()
                
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        
         }
            else
            {
                self.view.isUserInteractionEnabled = true
                hud.removeFromSuperview()
                self.showAlert(msg:"Please fill the data.")
            }
        }
    }
    
    
    func deleteRequest(fetchReq: NSFetchRequest<NSFetchRequestResult>) -> Void
    {
        //let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedObjectContext = Storage.shared.context//delegate.persistentContainer.viewContext
        do
        {
            let delAllData = NSBatchDeleteRequest(fetchRequest: fetchReq )
            try managedObjectContext.execute(delAllData)
            try managedObjectContext.save()
        }
        catch
        {
            print("Error with request: \(error)")
        }
        
    }
    func moveToNextClass()
    {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        self.deleteRequest(fetchReq: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)

        
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "campus") as! CampusSelectionVC
        
        UserDefaults.standard.set(true, forKey:"Login")
        
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //MARK: AlertController
    func showAlert(msg:String) -> Void
    {
        UIAlertController.Alert(title: "", msg: msg, vc: self)
    }
   
    @IBAction func btnFBSignUpClick(_ sender: Any)
    {
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            //fbLoginManager.loginBehavior = FBSDKLoginBehavior.systemAccount
            fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: self, handler:{ (result, error) -> Void in
           
                    print(error?.localizedDescription ?? "")
                   
                    if (error == nil) {
                       
                        let fbloginresult : FBSDKLoginManagerLoginResult = result!
                        
                        if(fbloginresult.grantedPermissions != nil)
                        {
                            if(fbloginresult.grantedPermissions.contains("email"))
                            {
                                self.getFBUserData()
                            }
                        }
                    }
            })
        }
    }

    
    
    func getFBUserData()
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

        if((FBSDKAccessToken.current()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).start(completionHandler: { (connection, result, error) -> Void in
                var dict = NSDictionary()
                dict = result as! NSDictionary
                
                print(dict)
                
                self.isRegisteredForLocalNotifications = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
                
                if (error == nil)
                {
                    
                    var getEmail : String!
                    
                    if let strEmail : String = dict.value(forKey: "email") as? String
                    {
                        getEmail = strEmail
                    }
                    else
                    {
                        getEmail = ""
                    }
                    let udid = UserDefaults.standard.value(forKey: "UID")
                    
                    if channelId == nil {
                        
                        channelId = UAirship.push().channelID
                    }
                    
                    //let dictUserInfo = ["fbuserid":dict.value(forKey: "id") as? String,"username":dict.value(forKey: "name") as?String,"email":getEmail,"first_name":dict.value(forKey: "first_name") as?String,"last_name":dict.value(forKey: "last_name") as?String,"phone":self.txtPhoneNumber.text?.Trim(),"userid":channelId,"UU_ID":udid as? String,"secure_token":"CMPS-FBginlo003"] as! [String : String]
                    
                    let dictUserInfo = ["fbuserid":dict.value(forKey: "id") as? String,"email":getEmail,"first_name":dict.value(forKey: "first_name") as?String,"last_name":dict.value(forKey: "last_name") as?String,"userid":channelId,"UU_ID":udid as? String,"secure_token":"CMPS-FBginlo003"] as! [String : String]
                    
                    print(dictUserInfo)
                    
        WebService.sharedInstance.postMethodWithParams(strURL: "fb_login.php", dict: dictUserInfo as NSDictionary, completionHandler:
                        {(dictReponse) in
                           
                            print(dictReponse)
                            
                                if (dictReponse.object(forKey: "success") != nil)
                                    {
                                        OperationQueue.main.addOperation
                                        {
                                            UserDefaults.standard.set("1", forKey: "911_alert_1")
                                            
                                            UserDefaults.standard.set("1", forKey: "911_alert_2")
                                            
                                            UserDefaults.standard.set("1", forKey: "911_alert_3")
                                            
                                            UserDefaults.standard.synchronize()
                                        
                                            alertizenUser.userData(dic: dictReponse as NSDictionary)
                                                
                                        UserDefaults.standard.set(true, forKey:"Facebook")

                                        UserDefaults.standard.set(false, forKey:"Scheduled")
                                            
                                        self.view.isUserInteractionEnabled = true
                                       
                                        hud.removeFromSuperview()
                                       
                                        if(self.isRegisteredForLocalNotifications == false)
                                        {
                                                let obj = self.storyboard?.instantiateViewController(withIdentifier: "accept") as! AcceptNotificationsVC
                                                UserDefaults.standard.set(false, forKey:"Login")
                                                self.navigationController?.pushViewController(obj, animated: true)
                                            }
                                            else
                                            {
                                                self.moveToNextClass()
                                            }
                                        
                                        }
                                    }
                            else
                            {
                                self.errorStr = dictReponse.object(forKey: "error") as! String
                                self.showAlert(msg:self.errorStr)
                                self.view.isUserInteractionEnabled = true
                                hud.removeFromSuperview()
                            }
                    } ,failure:{ (errorMsg) in
                        
                        self.view.isUserInteractionEnabled = true
                        
                        UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                        
                        hud.removeFromSuperview()
                    })
                    
                }
            })
          }
       }
    }
}
