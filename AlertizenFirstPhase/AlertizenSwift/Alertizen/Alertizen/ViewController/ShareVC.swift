//
//  ShareVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import MessageUI
import Social
import FBSDKShareKit

class ShareVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate
{

    @IBOutlet weak var shareTableView: UITableView!
    
    var items: [String] = ["Tell a Friend","Tell a Friend","Like us on Facebook"]

    var imagesArray: [String] = ["heart_icon","tellAFriend","shareFbLike_icon"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        shareTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.row == 0)
        {
            return 100
        }
        else
        {
            return 60
        }
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
        
        if (indexPath.row == 0)
        {
            cell.backgroundColor = UIColor.init(colorLiteralRed: 231/255.0, green: 77/255.0, blue: 61/255.0, alpha: 1)
            cell.profileImageView.isHidden = true
            cell.profileTitleLabel.isHidden = true
            
            let title = UILabel(frame: CGRect(x: 0, y:3, width: self.view.frame.size.width, height: 22))
            title.font = UIFont(name: "Bell MT", size: 16)!
            title.textAlignment = .center
            title.text = "Tell a Friend"
            title.textColor = UIColor.white
            cell.addSubview(title)
            
            let imgView = UIImageView(image: UIImage(named: "heart_icon"))
            imgView.contentMode = UIViewContentMode.scaleAspectFit
            imgView.frame = CGRect(x:(self.view.frame.size.width-80)/2,y:25,width:80,height:70)
            cell.addSubview(imgView)
        }
        else
        {
            cell.profileImageView.image = UIImage(named: imagesArray[indexPath.row])
            cell?.profileTitleLabel?.font = UIFont(name: "Bell MT", size: 18)!
            cell?.profileDoubleArrowIcon .isHidden = true
            cell.profileTitleLabel.text = items[indexPath.row]
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row {
            
        case 0: break
            
            
        case 1:
            
            self.showActionSheet()

        case 2:
            
            if UIApplication.shared.canOpenURL(URL(string: "fb://profile/\("577124435664807")")!) {
                UIApplication.shared.openURL(URL(string: "fb://profile/\("577124435664807")")!)
            }
            else {
                UIApplication.shared.openURL(URL(string: "https://www.facebook.com/\("577124435664807")/")!)
            }
            
        default: break
            
        }
    }
    
    
    // MARK:- ShowActionSheet
    func showActionSheet() -> Void {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let mailAction = UIAlertAction(title: "Mail", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            let mailComposeViewController = self.configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                
                self.present(mailComposeViewController, animated: true, completion: nil)
            }
            else {
                
                self.showSendMailErrorAlert()
            }
        })
        
        let msgAction = UIAlertAction(title: "Message", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            self.shareMessage()
        })
        
        let fbAction = UIAlertAction(title: "Facebook", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            self.shareFb()
        })
        
        let moreAction = UIAlertAction(title: "More", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            self.shareKit()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(mailAction)
        
        optionMenu.addAction(msgAction)
        
        optionMenu.addAction(fbAction)
        
        optionMenu.addAction(moreAction)
        
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK:- ShareFB
    func shareFb() -> Void {
        
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "https://alertizen.com")! as URL
        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
    }
    
    // MARK:- ShareKit
    func shareKit() -> Void {

        let textToShare = "Alertizen is the modernized Campus Watch and is a free service. The goal is to quickly notify you that a crime may be occurring in your neighborhood or around you, so you can get to safety and become the eyes and ears for the police."
        
        if let myWebsite = NSURL(string: "https://www.Alertizen.com") {
            
            let objectsToShare = [textToShare, myWebsite] as [Any]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // MARK:- MFMessageComposeView
    func shareMessage() -> Void {
        
        let composeVC = MFMessageComposeViewController()
        
        composeVC.messageComposeDelegate = self
        
        composeVC.body = "Join with me and become a member of Alertizen - The Campus Watch!.Download it today from https://alertizen.com/"
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- MFMailComposeView
    func configuredMailComposeViewController() -> MFMailComposeViewController
    {
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self
        
        let fullNameStr = String(format: "%@ %@",fname, lname)
        
        mailComposerVC.setSubject("Join with me and become a member of Alertizen - The Campus Watch!")
       
        mailComposerVC.setMessageBody("<html><body>Just a quick note to tell you about Alertizen - The Campus Watch that I recently joined.</br></br></br>Alertizen is the modernized Campus Watch and is a free service. The goal is to quickly notify you that a crime may be occurring in your neighborhood or around you so you can get to safety and become the eyes and ears for the police. True public safety is achieved when we share in the responsibility.</br></br></br>You can learn more about Alertizen at <a href=\"http://alertizen.com/\">http://alertizen.com/</a> and then signup and join me in creating safer neighborhoods.</br></br></br>\(fullNameStr)</body></html>", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        UIAlertController.Alert(title: "Could Not Send Email", msg: "Your device could not send e-mail.  Please check e-mail configuration and try again.", vc: self)
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension ShareVC: MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
