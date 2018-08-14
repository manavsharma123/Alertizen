//
//  TermAndCondViewController.swift
//  Alertizen
//
//  Created by MR on 24/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit

class TermAndCondViewController: UIViewController,UIWebViewDelegate
{
    var titleLabelText:NSString?

    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var scrollView:UIScrollView!

    var apiNameStr:String! = nil
    var keyStr:String! = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        titileLabel .text = titleLabelText as String?
        webView.isOpaque = false
        
        webView.backgroundColor = UIColor.clear
        
        if titileLabel.text == "TERMS & CONDITIONS"
        {
           apiNameStr = "terms.php"
           keyStr = "terms"
        }
        else
        {
           apiNameStr = "privacy.php"
           keyStr = "privacy"
        }
        
        loadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() -> Void
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        
        self.view.isUserInteractionEnabled = false
        let dictUserInfo = [String : String]()
        
        WebService.sharedInstance.postMethodWithParams(strURL: apiNameStr, dict: dictUserInfo as NSDictionary, completionHandler:
            { (dictReponse) in
                print(dictReponse)
                
                if (dictReponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                            let htmlCode = dictReponse.object(forKey:self.keyStr)
                            self.webView.loadHTMLString(htmlCode as! String, baseURL: nil)
                            hud.removeFromSuperview()
                            self.view.isUserInteractionEnabled = true
                        }
                }
        }, failure:{ (errorMsg) in
            print(errorMsg)
        })
    }
    
    func webViewDidFinishLoad(_ webView : UIWebView)
    {
        self.webView.frame = CGRect(x: self.webView.frame.origin.x , y: self.webView.frame.origin.y, width: self.webView.frame.size.width, height: self.webView.scrollView.contentSize.height)
        
        self.scrollView.contentSize = CGSize(width:0, height: self.webView.frame.origin.y+self.webView.frame.size.height)
        
        hud.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }

    @IBAction func btnInboxClick(_ sender: UIButton) -> Void
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editProfile = storyboard.instantiateViewController(withIdentifier: "InboxVC") as! InboxVC
        self.navigationController?.pushViewController(editProfile, animated: false)
    }
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
