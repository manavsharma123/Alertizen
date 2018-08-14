//
//  TermsNConditionsVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class TermsNConditionsVC: UIViewController, UIWebViewDelegate {

    var phone:String! = nil
    
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var btnDecline: UIButton!
    @IBOutlet var mainScrollView: UIScrollView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false
        
        loadData()
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() -> Void
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
        
        let dictUserInfo = ["secure_token":"CMPS-RTms889E"] as [String : String]

        WebService.sharedInstance.postMethodWithParams(strURL: "terms.php", dict: dictUserInfo as NSDictionary, completionHandler:
        { (dictReponse) in
            print(dictReponse)
            
            if (dictReponse.object(forKey: "success") != nil)
            {
                OperationQueue.main.addOperation
                {
                    let htmlCode = dictReponse.object(forKey: "terms")
                    
                    self.webView.loadHTMLString(htmlCode as! String, baseURL: nil)

                }
            }
            
        }, failure:{ (errorMsg) in
            
             UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            
                })
        }
    }
    
    @IBAction func btnAcceptClick(_ sender: AnyObject)
    {
        let obj = self.storyboard?.instantiateViewController(withIdentifier: "createProfile") as! CreateProfileVC
        
        obj.phoneStr = self.phone
        
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnDeclineClick(_ sender: AnyObject)
    {
        let rechability = Reachability.forInternetConnection()
        
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)            
        }
        else
        {
        
            let dictUserInfo = ["phone":phone,"secure_token":"CMPS-DleETeenDy007"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "delete_deny.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                        {
                            let _ = self.navigationController?.popToRootViewController(animated: false)
                        }
                    }
            }, failure:{ (errorMsg) in
                
                 UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView)
    {
        self.webView.frame = CGRect(x: self.webView.frame.origin.x , y: self.webView.frame.origin.y, width: self.webView.frame.size.width, height: self.webView.scrollView.contentSize.height)
        
        self.btnAccept.frame = CGRect(x: self.btnAccept.frame.origin.x , y: self.webView.frame.size.height+100, width: self.btnAccept.frame.size.width, height: self.btnAccept.frame.size.height)
        
        self.btnDecline.frame = CGRect(x: self.btnDecline.frame.origin.x , y: self.webView.frame.size.height+100, width: self.btnDecline.frame.size.width, height: self.btnDecline.frame.size.height)
        
        self.mainScrollView.contentSize = CGSize(width:0, height: self.btnDecline.frame.origin.y+self.btnDecline.frame.size.height)
        
        self.view.isUserInteractionEnabled = true
        
        hud.removeFromSuperview()
        
        mainScrollView.addSubview(self.btnAccept)

        mainScrollView.addSubview(self.btnDecline)
    }
}
