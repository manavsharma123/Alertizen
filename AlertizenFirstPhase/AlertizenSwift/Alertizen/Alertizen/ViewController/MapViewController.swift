//
//  MapViewController.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 21/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol ToggleSwitch
{
    func OnOffToggle(controller:MapViewController)
}

class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UISearchDisplayDelegate
{
    var EARTH_RADIUS = 6371000;
    var Radius = Int()
    var check = Bool()
    var polygon = GMSPolygon()
    var pos=GMSCameraPosition()
    var getAreaDetail = NSDictionary()
    var delegate:ToggleSwitch?
    var siwtchTag:Int?
    var radiusCircle = GMSCircle()
    var marker = GMSMarker()
    var errorStr:String! = nil
    var isTouchMap = Bool()
    var locationManager: CLLocationManager = CLLocationManager()
    var locationFixAchieved : Bool = false
    var areaTextString: String!
    var lat = Double()
    var long = Double()
    var isFirstTime = true
    var latOld = Double()
    var longOld = Double()
    var switchValueStr: String! = nil
    var distValueStr:String! = nil
    var checkTextUpdate = Bool()
    @IBOutlet var acceptNotiView: UIView!
    @IBOutlet var lblEnterAddress: UILabel!
    @IBOutlet weak var animatedMapBaseView: UIView!
    @IBOutlet weak var MonitoringAreaView: UIView!
    @IBOutlet weak var mapBaseView: GMSMapView!
    @IBOutlet weak var switchAction: UISwitch!
    @IBOutlet weak var EnterAddessView: UIView!
    @IBOutlet weak var lblEnabled: UILabel!
    @IBOutlet var btnRadio1:ISRadioButton!
    @IBOutlet var btnRadio2:ISRadioButton!
    @IBOutlet var btnRadio3:ISRadioButton!
    @IBOutlet weak var areaTxtField: UITextField!
    @IBOutlet weak var cpyRightVw: UIView!
    @IBOutlet weak var enterAdrsVw: UIView!
    @IBOutlet weak var enterAdrLbl:UILabel!
    @IBOutlet weak var areaLbl:UILabel!
    @IBOutlet weak var whiteView:UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        check = true
        //Enter Address View - Search Address
        checkTextUpdate = false
        UserDefaults.standard.set("3", forKey:"switchSet")
        enterAdrsVw.backgroundColor = UIColor(red: 249.0/255.0, green: 220.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        enterAdrsVw.layer.cornerRadius = 5
        enterAdrsVw.layer.borderWidth = 1
        enterAdrsVw.layer.borderColor = UIColor(red: 232.0/255.0, green: 92.0/255.0, blue: 82.0/255.0, alpha: 1.0).cgColor
        
        self.distValueStr = "1.00"
        
        self.btnRadio2.touchDown()
       
        switchAction.tag = siwtchTag!
        
        if (self.switchAction.tag != 4)
        {
            lblEnabled.text = "• Activate this Monitoring Area by sliding the toggle in the upper right corner of this screen to the right.  It will turn green and take you to the map screen. \n \n• On the Map Screen tap into the Monitoring Area Title where you can rename it to whatever you like such as: My House or Mom’s House, etc. \n \n• On the Map Screen tap into the Address field and enter the address you want to monitor.  You can then push the map with your finger to adjust the location of your monitoring area to your required position."
            lblEnabled.frame = CGRect(x:lblEnabled.frame.origin.x,y:lblEnabled.frame.origin.y,width:lblEnabled.frame.size.width,height:lblEnabled.frame.height+140)
        }
        else
        {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        getMonitoringAreaDetail()
        
    }
    
    func showSettingAlert()
    {
        // Create the alert controller
        let alertController = UIAlertController(title: "Location", message: "Please turn on Location Services", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
           
            guard let settingsUrl =  URL(string: UIApplicationOpenSettingsURLString) else
            {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl)
            {
                if #available(iOS 10.0, *)
                {
                    UIApplication.shared.open(settingsUrl, completionHandler:
                        {
                            (success) in
                            print("Settings opened: \(success)") // Prints true
                            
                            let _ = self.navigationController?.popViewController(animated: false)
                            
                    })
                } else
                {
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                    let _ = self.navigationController?.popViewController(animated: false)
                    // Fallback on earlier versions
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(settingsAction)
        
        alertController.addAction(cancelAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func getMonitoringAreaDetail() -> Void
    {
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            
            whiteView.isHidden = false
            
//            hud.show(true)
//            hud.frame = self.view.frame
//            hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
//            hud.color = UIColor.clear
//            self.view.addSubview(hud)
            
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            
            let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let dictUserInfo = ["userId":detail_Dict as AnyObject,"mon_area":siwtchTag as AnyObject,"phone":phnNo as AnyObject,"device_token":channelId! as AnyObject,"and_channel_id":channelId! as AnyObject,"device_type":"1" as AnyObject,"secure_token":"CMPS-GetArea008Details" as AnyObject]  as [String : AnyObject]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "get_area_details.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                            {
                                self.getAreaDetail = dictReponse["monitoring_area"] as! NSDictionary
                                
                                if self.siwtchTag == 4
                                {
                                    self.areaTextString =  "Mobile Monitoring"
                                    self.areaTxtField.isHidden = true
                                    self.areaLbl.isHidden = false
                                    self.areaLbl.text =  self.areaTextString
                                    self.EnterAddessView.isHidden = true
                                    self.mapBaseView.isUserInteractionEnabled = false
                                    let status = self.getAreaDetail["status"] as? String
                                    if status == "1"
                                    {
                                        self.switchAction.setOn(true, animated: false)
                                        self.mapBaseView.isHidden = false
                                        self.switchValueStr = "1"
                                        self.distValueStr = "2.00"
                                        self.getCurrentLoc()
                                        self.createCurentLocBtn()
                                        self.whiteView.isHidden = true
                                        hud.removeFromSuperview()
                                    }
                                    else
                                    {
                                        self.acceptNotiView.isHidden = true
                                        self.switchAction.setOn(false, animated: true)
                                        self.mapBaseView.isHidden = true
                                        self.switchValueStr = "0"
                                        self.distValueStr = "2.00"
                                        self.whiteView.isHidden = true
                                        hud.removeFromSuperview()
                                    }
                                }
                                else
                                {
                                    if let status = self.getAreaDetail["status"] as? String
                                    {
                                        if status == "1"
                                        {
                                            self.switchAction.setOn(true, animated: false)
                                            self.lblEnabled.isHidden = true
                                            self.mapBaseView.isHidden = false
                                            self.EnterAddessView.isHidden = false
                                            if let address = self.getAreaDetail["address"] as? String
                                            {
                                                self.lblEnterAddress.text = address
                                            }
                                            self.areaTextString = self.getAreaDetail["area_name"] as! String
                                            self.areaTxtField.isHidden = false
                                            self.areaTxtField.text = self.areaTextString
                                            self.areaLbl.isHidden = true
                                            self.switchValueStr = "1"
                                            if let distStr = self.getAreaDetail["distance"] as? String
                                            {
                                                if distStr == "1.50"
                                                {
                                                    self.distValueStr = "1.50"
                                                    self.btnRadio1.touchDown()
                                                }
                                                    else if distStr == "2.00"
                                                {
                                                    self.distValueStr = "2.00"
                                                    self.btnRadio3.touchDown()
                                                }
                                                else
                                                {
                                                    self.distValueStr = "1.00"
                                                    self.btnRadio2.touchDown()
                                                }
                                            }
                                            self.getCurrentLoc()
                                            self.whiteView.isHidden = true
                                            hud.removeFromSuperview()
                                        }
                                        else
                                        {
                                            
                                            self.switchAction.setOn(false, animated: true)
                                            self.areaTxtField.isHidden = true
                                            self.lblEnabled.isHidden = false
                                            self.mapBaseView.isHidden = true
                                            self.areaTextString = self.getAreaDetail["area_name"] as! String
                                            self.areaLbl.isHidden = false
                                            self.areaLbl.text = self.areaTextString
                                            self.areaTxtField.isHidden = true
                                            self.switchValueStr = "0"
                                            if let distStr = self.getAreaDetail["distance"] as? String
                                            {
                                                if distStr == "1.50"
                                                {
                                                    self.distValueStr = "1.50"
                                                    self.btnRadio1.touchDown()
                                                }
                                                else if distStr == "2.00"
                                                {
                                                    self.distValueStr = "2.00"
                                                    self.btnRadio3.touchDown()
                                                }
                                                else
                                                {
                                                    self.distValueStr = "1.00"
                                                    self.btnRadio2.touchDown()
                                                }
                                            }
                                            self.whiteView.isHidden = true
                                            hud.removeFromSuperview()
                                        }
                                        
                                    }
                                    
                                }
                        }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        UIAlertController.Alert(title: "", msg: self.errorStr, vc: self)
                        self.whiteView.isHidden = true
                        hud.removeFromSuperview()
                    }
                    
            }, failure:{ (errorMsg) in
                print(errorMsg)
            })
        }
    }
    
    func getCurrentLoc()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            if self.siwtchTag == 4
            {
                let status = CLLocationManager.authorizationStatus()
           
                if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined)
                {
                    acceptNotiView.isHidden = false
                   
                    hud.removeFromSuperview()
                }
                else
                {
                    acceptNotiView.isHidden = true
                    
                    locationManager.delegate = self
                    
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    
                    locationManager.startUpdatingLocation()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

                         self.lat = (self.locationManager.location?.coordinate.latitude)!
                        
                         self.long = (self.locationManager.location?.coordinate.longitude)!
                        
                        if let strLat : String = self.getAreaDetail["latitude"] as? String, let strLongi : String = self.getAreaDetail["longitude"] as? String
                        {
                            if strLat.isEmpty {
                                
                                 self.latOld =  self.lat
                                
                                 self.longOld =  self.long
                            }
                            else {
                                
                                 self.latOld = Double(strLat)!
                                
                                 self.longOld = Double(strLongi)!
                            }
                        }
                        else
                        {
                             self.latOld =  self.lat
                            
                             self.longOld =  self.long
                        }
                        
                        UserDefaults.standard.set(self.latOld, forKey:"latitudeOld")
                       
                        UserDefaults.standard.set(self.longOld, forKey:"longitudeOld")
                        
                        self.mapBaseView.clear()
                    }
                   // createCircle()
                }
            }
            else
            {
                locationManager.delegate = self
                
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
               
                locationManager.startUpdatingLocation()
                
                if let strLat : String = self.getAreaDetail["latitude"] as? String, let strLongi : String = self.getAreaDetail["longitude"] as? String
                {
                    if strLat.isEmpty {
                        
                        lat = 41.6670429
                        
                        long =  -83.55232050
                    }
                    else {
                        
                        lat = Double(strLat)!
                        
                        long = Double(strLongi)!
                    }
                    
                    latOld = lat
                    
                    longOld = long
                }
                else
                {
                    lat = 41.6670429
                    
                    long =  -83.55232050
                    
                    latOld = lat
                    
                    longOld = long
                }
                
                mapBaseView.clear()
                
                createCircle()
            }
            
        }
        else
        {
            UIAlertController.Alert(title: "", msg: "Location services are not enabled", vc: self)
        }
        
    }
    
    func createCurentLocBtn()
    {
        let curentLocBtn  = UIButton()
        curentLocBtn.autoresizingMask = [.flexibleRightMargin,.flexibleLeftMargin, .flexibleBottomMargin,.flexibleTopMargin]
        
        if (switchAction.tag == 4)
        {
            curentLocBtn.frame = CGRect(x:self.view.frame.width-50,y:20,width:40,height:40)
        }
        
        curentLocBtn.setImage(UIImage(named:"location.jpg"), for: UIControlState.normal)
        curentLocBtn.addTarget(self, action: #selector(MapViewController.btnCurrentLocationClick(sender:)), for: .touchUpInside)
        mapBaseView.addSubview(curentLocBtn)
    }
    
    // Delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if (self.switchAction.tag == 4)
        {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            
            lat = locValue.latitude
            
            long  = locValue.longitude
            
            let newLoc = CLLocation(latitude: latOld, longitude: longOld)
            let rismanPlaza = CLLocation(latitude: lat, longitude: long)
            let distanceMeters = newLoc.distance(from: rismanPlaza)
            let distanceKM = distanceMeters / 1000
            let feet = distanceKM * 3280.84
    
            if (self.switchAction.tag != 4) {

            mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: locValue.latitude,longitude: locValue.longitude),zoom:12.75)
                
            }
            else {
                
                mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: locValue.latitude,longitude: locValue.longitude),zoom:13.25)
            }
           
            self.marker.position = locValue
            mapBaseView.clear()
            self.createCircle()
//            self.radiusCircle.position = locValue
            
            print(feet)
            
            if feet > 500
            {
                self.view.isUserInteractionEnabled = false
                
                latOld = lat
                
                longOld = long
                
                UserDefaults.standard.set(latOld, forKey:"latitudeOld")
                
                UserDefaults.standard.set(longOld, forKey:"longitudeOld")
                
                self.updateMonitoringDetail()
            }
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)
    {
        if (self.switchAction.tag == 4)
        {
            
          lat = position.target.latitude
            
          long  = position.target.longitude
            
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool)
    {
        isTouchMap = true
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        if (self.switchAction.tag != 4)
        {
            self.view.isUserInteractionEnabled = false
            self.mapBaseView.isUserInteractionEnabled = false
            lat = position.target.latitude
            long  = position.target.longitude
            self.marker.position = position.target
            
//            self.radiusCircle.position = position.target
            mapBaseView.clear()
            self.updateCircle()
            //Getting Address
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.lat, longitude: self.long)
            geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
                
                if error == nil {
                    
                    let placeArray = placemarks as [CLPlacemark]!
                    
                    // Place details
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    // Address dictionary
                    
                    ///  print(placeMark)
                    
                    var locationName = ""
                    var city = ""
                    var state = ""
                    var country = ""
                    
                    if let a = placeMark.addressDictionary?["Name"] as? String
                    {
                        locationName = a
                    }
                    
                    if let b = placeMark.addressDictionary?["City"] as? String
                    {
                        city = b
                    }
                    
                    if let c = placeMark.addressDictionary?["State"] as? String
                    {
                        state = c
                    }
                    
                    if let d = placeMark.country
                    {
                        country = d
                    }
                    

                        self.lblEnterAddress.text = String(format:"%@,%@,%@,%@",locationName,city,state,country)
                
                   
                }
                if (self.switchAction.tag != 4)
                {
                    let updateDic : NSDictionary = UserDefaults.standard.value(forKey:"getMapUpdateDetails") as! NSDictionary
                    if updateDic.count == 1
                    {
                        self.view.isUserInteractionEnabled = false
                        self.mapBaseView.isUserInteractionEnabled = false
                        self.updateMonitoringDetail()
                    }
                    else
                    {
                        if self.check == true
                        {
                            self.check = false
                            self.view.isUserInteractionEnabled = true
                            self.mapBaseView.isUserInteractionEnabled = true
//
                        }
                        else
                        {
                            self.view.isUserInteractionEnabled = false
                            self.mapBaseView.isUserInteractionEnabled = false
                            self.updateMonitoringDetail()
                        }
                    }
                    
                }
            }
            let updateDic : NSDictionary = UserDefaults.standard.value(forKey:"getMapUpdateDetails") as! NSDictionary
            if updateDic.count == 1
            {
                hud.show(true)
                hud.frame = self.view.frame
                hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
                hud.color = UIColor.clear
                self.view.addSubview(hud)
            }
            else
            {
                if self.check == true
                {
                    
                }
                else
                {
                    hud.show(true)
                    hud.frame = self.view.frame
                    hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
                    hud.color = UIColor.clear
                    self.view.addSubview(hud)
                }
            }
           
//            if (self.switchAction.tag != 4)
//            {
//                self.view.isUserInteractionEnabled = false
//                self.mapBaseView.isUserInteractionEnabled = false
//                self.updateMonitoringDetail()
//            }
            
        }
        
    }
    
    func updateCirclePosition()
    {
        radiusCircle.fillColor = UIColor(red: 250/255, green: 230/255, blue: 237/255, alpha: 0.5)
        radiusCircle.strokeColor = UIColor(red: 244/255, green: 190/255, blue: 218/255, alpha: 1.0)
//        self.radiusCircle.position = pos.target
        mapBaseView.clear()
        self.createCircle()
        if (self.switchAction.tag != 4)
        {
            self.view.isUserInteractionEnabled = false
            self.mapBaseView.isUserInteractionEnabled = false
            self.updateMonitoringDetail()
        }
    }
    
    func updateCircle() {
    
        let pointForLatLong = 8
        
        var arrLatLong = [CLLocationCoordinate2D]()
        
        let rect = GMSMutablePath()
        ///
        if distValueStr == "1.50"
        {
            Radius = 575
        }
        else if distValueStr == "1.00"
        {
            Radius = 1150
        }
        else
        {
            Radius = 2300
        }
        
//        if distValueStr == "1.50"
//        {
//            Radius = 402
//        }
//        else if distValueStr == "0.095"
//        {
//            Radius = 804
//        }
//        else
//        {
//            Radius = 785
//        }
        ///
        
        
        ///
        for i in 0..<8 {
            
            if i % 2 != 0 {
                
                let newVal = i * 2
                
                arrLatLong.append(self.getLatLong(center: CLLocationCoordinate2DMake(lat,long), radius: Radius, angle: Double(newVal) * .pi / Double(pointForLatLong)))
            }
        }
        
        for latLong in arrLatLong {
            
            rect.add(latLong)
        }
        
        polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 250/255, green: 230/255, blue: 237/255, alpha: 0.5)
        polygon.strokeColor = UIColor(red: 244/255, green: 190/255, blue: 218/255, alpha: 1.0)
        polygon.strokeWidth = 1.5
        polygon.map = mapBaseView
        
        
        //Add Marker
        let position = CLLocationCoordinate2DMake(lat, long)
        marker = GMSMarker(position: position)
        self.mapBaseView.delegate = self
        marker.map = self.mapBaseView
        marker.icon = self.imageWithImage(image: UIImage(named: "alertizen_icon.png")!, scaledToSize: CGSize(width:40, height:50))
        self.updateMonitoringDetail()
        }
    
    // Create Circle
    func createCircle()
        {
            let pointForLatLong = 8
    
            var arrLatLong = [CLLocationCoordinate2D]()
    
            let rect = GMSMutablePath()
            //"1.50"1.00"2.00
            if distValueStr == "1.50"
            {
               Radius = 575
            }
            else if distValueStr == "1.00"
            {
                 Radius = 1150
            }
            else
            {
                Radius = 2300
            }
            for i in 0..<8 {
    
                if i % 2 != 0 {
    
                    let newVal = i * 2
    
                    arrLatLong.append(self.getLatLong(center: CLLocationCoordinate2DMake(lat,long), radius: Radius, angle: Double(newVal) * .pi / Double(pointForLatLong)))
                }
            }
            
            if (self.switchAction.tag != 4) {

                mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat,longitude: long),zoom:12.75)
            }
            else {
                
                mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat,longitude: long),zoom:13.25)
            }
    
    
            for latLong in arrLatLong {
    
                rect.add(latLong)
            }
    
            polygon = GMSPolygon(path: rect)
            polygon.fillColor = UIColor(red: 250/255, green: 230/255, blue: 237/255, alpha: 0.5)
            polygon.strokeColor = UIColor(red: 244/255, green: 190/255, blue: 218/255, alpha: 1.0)
            polygon.strokeWidth = 1.5
            polygon.map = mapBaseView
    
    
            //Add Marker
            let position = CLLocationCoordinate2DMake(lat, long)
            marker = GMSMarker(position: position)
            self.mapBaseView.delegate = self
            marker.map = self.mapBaseView
            marker.icon = self.imageWithImage(image: UIImage(named: "alertizen_icon.png")!, scaledToSize: CGSize(width:40, height:50))
           self.updateMonitoringDetail()
        }
    
    func getLatLong(center: CLLocationCoordinate2D, radius: Int, angle: Double) -> CLLocationCoordinate2D {
        
        let east = Double(radius) * cos(angle)
        
        let north = Double(radius) * sin(angle)
        
        let cLat = center.latitude
        let cLng = center.longitude
        
        let latRadius = Double(EARTH_RADIUS) * cos(cLat / 180 * .pi )
        
        let newLat = cLat + (north / Double(EARTH_RADIUS) / .pi * 180)
        let newLng = cLng + (east / latRadius / .pi * 180)
        
        let latLong = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
        
        return latLong
    }
//    {
//        //Add Circle to Map
//
//        if distValueStr == "1.50"
//        {
//            radiusCircle = GMSCircle(position: CLLocationCoordinate2DMake(lat,long), radius: 402)
//            mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat,longitude: long),zoom:14)
//
//        }
//        else if distValueStr == "0.095"
//        {
//            radiusCircle = GMSCircle(position: CLLocationCoordinate2DMake(lat,long), radius: 804)
//            mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat,longitude: long),zoom:14)
//        }
//        else
//        {
//            radiusCircle = GMSCircle(position: CLLocationCoordinate2DMake(lat,long), radius: 785)
//            mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat,longitude: long),zoom:14)
//        }
//        radiusCircle.fillColor = UIColor(red: 250/255, green: 230/255, blue: 237/255, alpha: 0.5)
//        radiusCircle.strokeColor = UIColor(red: 244/255, green: 190/255, blue: 218/255, alpha: 1.0)
//        radiusCircle.strokeWidth = 1.5
//
//        radiusCircle.map = self.mapBaseView
//
//        //Add Marker
//        let position = CLLocationCoordinate2DMake(lat, long)
//        marker = GMSMarker(position: position)
//        self.mapBaseView.delegate = self
//        marker.map = self.mapBaseView
//        marker.icon = self.imageWithImage(image: UIImage(named: "alertizen_icon.png")!, scaledToSize: CGSize(width:70, height:80))
//    }
    //Resize Marker Image
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize,false,0.0)
        image.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //Update Area Monitoring
    func updateMonitoringDetail()
    {
        let rechability = Reachability.forInternetConnection()
        let remoteHostStatus = rechability?.currentReachabilityStatus()
        
        if (remoteHostStatus == NotReachable)
        {
            UIAlertController.Alert(title: "Network Unavailable", msg: "Please connect to the internet in order to proceed.", vc: self)
            
        }
        else
        {
            if CLLocationManager.locationServicesEnabled()
            {
                
//                hud.show(true)
//                hud.frame = self.view.frame
//                hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
//                hud.color = UIColor.clear
//                self.view.addSubview(hud)
                
                let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
                
                let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
                
                let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
                
                var dictUserInfo :  [String : AnyObject]
                
                if (self.switchAction.tag == 4)
                {
                    dictUserInfo = ["userId":detail_Dict as AnyObject,"mon_area":siwtchTag as AnyObject,"mon_name":"Mobile Monitoring" as AnyObject,"address":lblEnterAddress.text as AnyObject,"distance":"2.00" as AnyObject,"latitude":lat as AnyObject,"longitude":long as AnyObject,"status":switchValueStr as AnyObject,"phone":phnNo as AnyObject,"device_token":channelId! as AnyObject,"and_channel_id":channelId! as AnyObject,"device_type":"1" as AnyObject,"secure_token":"CMPS-vncSx3ghGaW" as AnyObject]
                }
                else
                {
                    dictUserInfo = ["userId":detail_Dict as AnyObject,"mon_area":siwtchTag as AnyObject,"mon_name":areaTxtField.text as AnyObject,"address":lblEnterAddress.text as AnyObject,"distance":distValueStr as AnyObject,"latitude":lat as AnyObject,"longitude":long as AnyObject,"status":switchValueStr as AnyObject,"phone":phnNo as AnyObject,"device_token":channelId! as AnyObject,"and_channel_id":channelId! as AnyObject,"device_type":"1" as AnyObject,"secure_token":"CMPS-vncSx3ghGaW" as AnyObject]
                    
                }
                
                print(dictUserInfo)
                
                WebService.sharedInstance.postMethodWithParams(strURL: "update_area.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                    { (dictReponse) in
                        
                        print(dictReponse)
                        
                        if (dictReponse.object(forKey: "success") != nil)
                        {
                            OperationQueue.main.addOperation
                            {
                                if (self.switchAction.tag == 4)
                                {
                                
                                    _ =  Timer.scheduledTimer(timeInterval:0.50, target: self, selector: #selector(MapViewController.dismissLoader), userInfo: nil, repeats: false)
                                }
                                else
                                {
                                    UserDefaults.standard.set(dictUserInfo, forKey:"getMapUpdateDetails")
                                    _ =  Timer.scheduledTimer(timeInterval:0.50, target: self, selector: #selector(MapViewController.dismissLoader), userInfo: nil, repeats: false)
                                }
                            }
                        }
                        else
                        {
                            self.errorStr = dictReponse.object(forKey: "error") as! String
                            UIAlertController.Alert(title: "", msg: self.errorStr, vc: self)
                            hud.removeFromSuperview()
                            self.view.isUserInteractionEnabled = true
                            self.mapBaseView.isUserInteractionEnabled = true
                        }
                        
                }, failure:{ (errorMsg) in
                    self.view.isUserInteractionEnabled = true
                    self.mapBaseView.isUserInteractionEnabled = true
                    hud.removeFromSuperview()
                    
                    UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                })
            }
            else
            {
                UIAlertController.Alert(title: "", msg: "Location services are not enabled", vc: self)
            }
        }
    }
    
    func dismissLoader()
    {
        hud.removeFromSuperview()
        areaTxtField.resignFirstResponder()
        self.view.isUserInteractionEnabled = true
        self.switchAction.isUserInteractionEnabled = true
        if (self.switchAction.tag != 4)
        {
            self.mapBaseView.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func ToggleSwitch(_ sender: UISwitch)
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        if sender.isOn
        {
            switchAction.isUserInteractionEnabled = false
            switchValueStr  = "1"
            lblEnabled.isHidden = true
            EnterAddessView.isHidden = false
            animatedMapBaseView.isHidden = false
            mapBaseView.isHidden = false
            areaTxtField.isHidden = false
            areaTxtField.text = areaTextString
            areaLbl.isHidden = true
          

            
            if CLLocationManager.locationServicesEnabled()
            {
                
                if (switchAction.tag == 4)
                {
                    UserDefaults.standard.set(true, forKey:"mobileMontOn")
                    
                    areaTxtField.isHidden = true
                    areaLbl.isHidden = false
                    areaLbl.text = areaTextString
                    EnterAddessView.isHidden = true
                    
                    if sender.isOn
                    {
                        mapBaseView.isHidden = false
                        UserDefaults.standard.set("1", forKey:"switchSet")
                        UserDefaults.standard.set("1", forKey:"UpdateswitchSet")
                        
                    }
                    else
                    {
                        mapBaseView.isHidden = true
                        UserDefaults.standard.set("0", forKey:"switchSet")
                        UserDefaults.standard.set("0", forKey:"UpdateswitchSet")
                    }
                   
                    let status = CLLocationManager.authorizationStatus()
                    if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined)
                    {
                        self.getCurrentLoc()
                    }
                    else
                    {
                        self.getCurrentLoc()
                        self.createCurentLocBtn()
                        updateMonitoringDetail()
                    }
                }
                else
                {
                    refreshGetMont()
                }
                
            }
            else
            {
                UIAlertController.Alert(title: "", msg: "Location services are not enabled", vc: self)
                self.switchAction.isUserInteractionEnabled = true
            }
            
        }
        else
        {
            switchValueStr  = "0"
            animatedMapBaseView.isHidden = true
            EnterAddessView.isHidden = true
            lblEnabled.isHidden = false
            mapBaseView.isHidden = true
            areaLbl.isHidden = false
            areaLbl.text = areaTextString
            areaTxtField.isHidden = true
            
            if CLLocationManager.locationServicesEnabled()
            {
                
                if (switchAction.tag == 4)
                {
                    let status = CLLocationManager.authorizationStatus()
                    if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined)
                    {
                        acceptNotiView.isHidden = false
                    }
                    else
                    {
                        acceptNotiView.isHidden = true
                        UserDefaults.standard.set(false, forKey:"mobileMontOn")
                        areaTxtField.isHidden = true
                        areaLbl.isHidden = false
                        areaLbl.text = areaTextString
                        EnterAddessView.isHidden = true
                        
                        if sender.isOn
                        {
                            mapBaseView.isHidden = false
                            UserDefaults.standard.set("1", forKey:"switchSet")
                            UserDefaults.standard.set("1", forKey:"UpdateswitchSet")
                        }
                        else
                        {
                            mapBaseView.isHidden = true
                            UserDefaults.standard.set("0", forKey:"switchSet")
                            UserDefaults.standard.set("0", forKey:"UpdateswitchSet")
                        }
                        updateMonitoringDetail()
                    }
                }
                else
                {
                    updateMonitoringDetail()
                }
            }
            else
            {
                //// UIAlertController.Alert(title: "", msg: "Location services are not enabled", vc: self)
            }
        }
        
        hud.removeFromSuperview()
        
        areaTxtField.resignFirstResponder()
    }
    
    
    func refreshGetMont()
    {
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        
        let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
        
        let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
        
        let dictUserInfo = ["userId":detail_Dict as AnyObject,"mon_area":siwtchTag as AnyObject,"phone":phnNo as AnyObject,"device_token":channelId! as AnyObject,"and_channel_id":channelId! as AnyObject,"device_type":"1" as AnyObject,"secure_token":"CMPS-GetArea008Details" as AnyObject]  as [String : AnyObject]
        
        print(dictUserInfo)
        
        WebService.sharedInstance.postMethodWithParams(strURL: "get_area_details.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
            { (dictReponse) in
                
                print(dictReponse)
                
                if (dictReponse.object(forKey: "success") != nil)
                {
                    OperationQueue.main.addOperation
                        {
                            self.getAreaDetail = dictReponse["monitoring_area"] as! NSDictionary
                            self.getCurrentLoc()
                            self.updateMonitoringDetail()
                        }
                }
        }, failure:{ (errorMsg) in
            print(errorMsg)
        })
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Back Button Click
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        if CLLocationManager.locationServicesEnabled()
        {
            if (switchAction.tag == 4)
            {
                let _ = self.navigationController?.popViewController(animated: true)
            }
            else
            {
                areaTxtField.resignFirstResponder()
                if switchValueStr == "1"
                {
                    if(self.lblEnterAddress.text == "Enter Address")
                    {
                        UIAlertController.Alert(title: "", msg: "Please Enter Address", vc: self)
                    }
                    else
                    {
                        if switchValueStr == "1"
                        {
//                          let  dictUserInfo = ["mon_area":siwtchTag as AnyObject,"mon_name":areaTxtField.text as AnyObject,"address":lblEnterAddress.text as AnyObject,"distance":distValueStr as AnyObject,"latitude":lat as AnyObject,"longitude":long as AnyObject,"status":switchValueStr as AnyObject,"device_token":channelId! as AnyObject,"and_channel_id":channelId! as AnyObject,"device_type":"1" as AnyObject]
//                            
//                            
//                            UserDefaults.standard.set(dictUserInfo, forKey:"getMapUpdateDetails")
                            
                            if checkTextUpdate == true
                            {
                               updateMonitoringDetail()
                                _ =  Timer.scheduledTimer(timeInterval:1.5, target: self, selector: #selector(MapViewController.popToBack), userInfo: nil, repeats: false)
                            }
                            else
                            {
                                let _ = self.navigationController?.popViewController(animated: true)
                            }
                        
                        }
                        else
                        {
                            let _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                else
                {
                    let _ = self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else
        {
            let _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToBack()
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func distanceSelection(_ sender: ISRadioButton)
    {
        
    }
    
    @IBAction func logSelectedButton(_ isRadioButton:ISRadioButton)
    {
        areaTxtField.resignFirstResponder()
        if(isRadioButton.tag == 1)
        {
            radiusCircle.radius = 575.0
            distValueStr = "1.50"
        }
        else  if(isRadioButton.tag == 2)
        {
            radiusCircle.radius = 1150.0
            distValueStr = "1.00"
        }
        else{
            
            radiusCircle.radius = 2300.0
            distValueStr = "2.00"
        }
        mapBaseView.clear()
        createCircle()
        
    }
    
    @IBAction func btnCurrentLocationClick(sender:UIButton) {
    
        mapBaseView.clear()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            let status = CLLocationManager.authorizationStatus()
            
            if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined) {
                
                acceptNotiView.isHidden = false
            }
            else {
                
                acceptNotiView.isHidden = true
                
                locationManager.delegate = self
                
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                
                locationManager.startUpdatingLocation()
                
                lat = (locationManager.location?.coordinate.latitude)!
                
                long = (locationManager.location?.coordinate.longitude)!
                
                latOld = lat
                
                longOld = long
                
                createCircle()
                
            }
        }
        else {
           
            UIAlertController.Alert(title: "", msg: "Location services are not enabled", vc: self)
        }
        
    }
    
    //MARK: TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        areaTextString = areaTxtField.text
        
        areaTxtField.text = ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(areaTxtField.text? .isEqual(""))!
        {
            areaTxtField.text = areaTextString
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        areaTextString = textField.text
        
        updateMonitoringDetail()
        
        return true
    }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    
    {
        checkTextUpdate = true
        return true
    }
    @IBAction func entrAdrsBtnClick(_ sender: UIButton)
    {
        if(areaTxtField.text? .isEqual(""))!
        {
            areaTxtField.text = areaTextString
        }
        updateMonitoringDetail()
        hud.removeFromSuperview()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnAlertNextClick(_ sender: UIButton) -> Void
    {
        showSettingAlert()
    }
    
    @IBAction func btnAlertBackClick(_ sender: UIButton) -> Void
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}

extension MapViewController: GMSAutocompleteViewControllerDelegate
{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        mapBaseView.clear()
        
        lat = place.coordinate.latitude
        
        long = place.coordinate.longitude
        
        lblEnterAddress.text = place.name
        
        createCircle()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
