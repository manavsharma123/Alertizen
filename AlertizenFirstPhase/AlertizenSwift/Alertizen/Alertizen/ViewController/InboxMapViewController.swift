//
//  InboxMapViewController.swift
//  Alertizen
//
//  Created by Mind Root on 24/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds

class InboxMapViewController: UIViewController,CLLocationManagerDelegate,GADInterstitialDelegate
{

    @IBOutlet weak var mapBaseView: GMSMapView!
    @IBOutlet weak var dateTmLbl : UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAddress: UILabel!
   
    var locationManager: CLLocationManager = CLLocationManager()
    
    var locationFixAchieved : Bool = false
    
    var lat: String!
    
    var long: String!
    
    var strTitle: String!

    var strAddress: String!
    
    var strDate: String!
    
    var bannerView: GADBannerView!
   
    var interstitial: GADInterstitial!

    //MARK:- vvvv
    override func viewDidLoad() {
      
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
        
        bannerView.frame.origin.y = (DeviceInfo.TheCurrentDeviceHeight - 10) - bannerView.frame.size.height
        
        bannerView.frame.size.width = DeviceInfo.TheCurrentDeviceWidth
        
       // live
       // bannerView.adUnitID = "ca-app-pub-7570537979095777/1053282051"
        
   
       // test from 786 acc banner
       // ca-app-pub-6849765509322868/6628030911
   
        bannerView.adUnitID = "ca-app-pub-6229411317924470/4261554156"
        
        bannerView.rootViewController = self
        
        self.view.addSubview(bannerView)
        
        bannerView.load(GADRequest())
        
        // live
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-7570537979095777/8942723825")
        
        // test from 786 acc
        //        ca-app-pub-6849765509322868/2238317629
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-6229411317924470/7808071016")
        
        interstitial.delegate = self
        
        interstitial.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
        
        self.getCurrentLoc()
        
        self.createCrntLocBtn()
        
        lblTitle.text = strTitle
        
        dateTmLbl.text = strDate
        
        lblAddress.text = strAddress
    }
    
     //Resize Marker Image
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage {
       
        UIGraphicsBeginImageContextWithOptions(newSize,false,0.0)
        
        image.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height))
       
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
       
        UIGraphicsEndImageContext()
       
        return newImage
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func getCurrentLoc() {
      
        locationFixAchieved = false
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            locationManager.startUpdatingLocation()
        }
       
        //Add Marker
        let position = CLLocationCoordinate2DMake(Double(lat)! ,Double(long)!)
        
        let marker = GMSMarker(position: position)
        
        marker.map = self.mapBaseView
        
        marker.icon = self.imageWithImage(image: UIImage(named: "alertizen_icon.png")!, scaledToSize: CGSize(width:60, height:65))
        
        mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: Double(lat)!,longitude: Double(long)!),zoom:15)

        //  hud.removeFromSuperview()

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if (locationFixAchieved == false) {
           
            locationFixAchieved = true
           
            let target = CLLocationCoordinate2DMake(Double(lat)! ,Double(long)!)
            
            self.mapBaseView.animate(toLocation: target)
            
            self.mapBaseView.animate(toZoom: 15)
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) -> Void {
        
        let _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func createCrntLocBtn() {
        
        let btn  = UIButton()
        btn.autoresizingMask = [.flexibleRightMargin,.flexibleLeftMargin, .flexibleBottomMargin,.flexibleTopMargin]
        btn.frame = CGRect(x:self.view.frame.width-50,y:10,width:40,height:40)
        
        btn.setImage(UIImage(named:"location.jpg"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(MapViewController.btnCurrentLocationClick(sender:)), for: .touchUpInside)
        mapBaseView.addSubview(btn)
    }

    @IBAction func btnCurrentLocationClick(sender:UIButton) {
       
        self.getCurrentLoc()
    }
    
    //MARk:- Interstitial Delegate
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        
        print("interstitialDidReceiveAd")
        
        interstitial.present(fromRootViewController: self)
    }
}
