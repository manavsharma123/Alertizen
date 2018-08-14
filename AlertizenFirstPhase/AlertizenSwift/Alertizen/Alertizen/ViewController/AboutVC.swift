//
//  AboutVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var webView:UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        loadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() -> Void
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        self.view.isUserInteractionEnabled = false
        let dictUserInfo = ["secure_token":"CMPS-vncSx3ghGaW"] as! [String : String]
        
        WebService.sharedInstance.postMethodWithParams(strURL: "about.php", dict: dictUserInfo as NSDictionary, completionHandler:
            { (dictReponse) in
                
                if (dictReponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                    {
                        let htmlCode = dictReponse.object(forKey:"about_text")
                        self.webView.loadHTMLString(htmlCode as! String, baseURL: nil)
                        hud.removeFromSuperview()
                        self.view.isUserInteractionEnabled = true
                    }
                }
        }, failure:{ (errorMsg) in
           
        })
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnInboxClick(_ sender: UIButton) -> Void {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editProfile = storyboard.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
        self.navigationController?.pushViewController(editProfile, animated: false)
    }
}
