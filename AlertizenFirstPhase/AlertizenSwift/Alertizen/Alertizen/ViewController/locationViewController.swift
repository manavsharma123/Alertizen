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



class locationViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UISearchDisplayDelegate
{
    var check = Bool()
    var checktextfield = Bool()
    var pos=GMSCameraPosition()
    var getAreaDetail = NSDictionary()
    
  
    //var radiusCircle = GMSCircle()
    var marker = GMSMarker()
    var errorStr:String! = nil
    var isTouchMap = Bool()
    var locationManager: CLLocationManager = CLLocationManager()
    var locationFixAchieved : Bool = false
    var areaTextString: String!
    var lat : Double!
    var long : Double!
    var isFirstTime = true
    var latOld : Double!
    var longOld : Double!
    var switchValueStr: String! = nil
    var distValueStr:String! = nil
   
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var acceptNotiView: UIView!
    @IBOutlet var lblEnterAddress: UILabel!
    @IBOutlet weak var animatedMapBaseView: UIView!
    @IBOutlet weak var MonitoringAreaView: UIView!
    @IBOutlet weak var mapBaseView: GMSMapView!
    @IBOutlet weak var switchAction: UISwitch!
    @IBOutlet weak var EnterAddessView: UIView!
    @IBOutlet weak var lblEnabled: UILabel!
   
    @IBOutlet weak var areaTxtField: UITextField!
    @IBOutlet weak var cpyRightVw: UIView!
    @IBOutlet weak var enterAdrsVw: UIView!
    @IBOutlet weak var enterAdrLbl:UILabel!
    @IBOutlet weak var areaLbl:UILabel!
    @IBOutlet weak var whiteView:UIView!
    
    var zoomvalue = Float()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        zoomvalue = 3
        check = true
        checktextfield = false
        //Enter Address View - Search Address (red: 112.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        enterAdrsVw.backgroundColor = UIColor.white
        enterAdrsVw.layer.cornerRadius = 5
        
        //enterAdrsVw.layer.borderColor = UIColor(red: 232.0/255.0, green: 92.0/255.0, blue: 82.0/255.0, alpha: 1.0).cgColor
        
        self.distValueStr = "0.50"
        
        self.lblEnterAddress.text = "Sylvan Grove, KS  67481, Estados Unidos USA"
        
        UserDefaults.standard.set(self.lblEnterAddress.text, forKey:"createAddress")
        UserDefaults.standard.synchronize()

        self.load_map()
    }
    func load_map() -> Void {
        
        self.mapBaseView.isHidden = false
        
        animatedMapBaseView.isUserInteractionEnabled = false
        self.switchValueStr = "1"
        self.distValueStr = "0.095"
        self.getCurrentLoc()
        self.createCurentLocBtn()
        self.whiteView.isHidden = true
        
    }

    func showSettingAlert()
    {
        // Create the alert controller
        let alertController = UIAlertController(title: "Location", message: "Please turn on Location Services", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else
            {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl)
            {
                
                 let _ = self.navigationController?.popViewController(animated: false)
                
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
            
             let _ = self.navigationController?.popViewController(animated: false)
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
           
            let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let userID = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
            
            let dictUserInfo = ["userId":userID,"phone":phnNo,"device_token":channelId!,"and_channel_id":channelId!,"device_type":"1","secure_token":"CMPS-getM4566jkAr"] as [String : String]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "get_mon_area.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    if (dictReponse.object(forKey: "success") != nil)
                    {
                        OperationQueue.main.addOperation
                            {
                                self.view.isUserInteractionEnabled = true
                              
                                dictMonitoring = dictReponse.value(forKey: "monitoring_area") as! Dictionary
                                
                                self.switchAction.setOn(true, animated: false)
                                self.mapBaseView.isHidden = false
                                self.switchValueStr = "1"
                                self.distValueStr = "0.095"
                                self.getCurrentLoc()
                                self.createCurentLocBtn()
                                self.whiteView.isHidden = true
                                hud.removeFromSuperview()
                                
                                
                                
                        }
                    }
                    else
                    {
                        self.errorStr = dictReponse.object(forKey: "error") as! String
                        UIAlertController.Alert(title: "", msg: self.errorStr, vc: self)
                        self.view.isUserInteractionEnabled = true
                        hud.removeFromSuperview()
                    }
                    
            }, failure:{ (errorMsg) in
                
                self.view.isUserInteractionEnabled = true
               
                hud.removeFromSuperview()

                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            })
        }
    }
    
    func getCurrentLoc()
    {

                    acceptNotiView.isHidden = true
                    
                    locationManager.delegate = self
                    
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    
                    locationManager.startUpdatingLocation()

                    lat = 39.011901999999999
        
                    long = -98.484246499999998

                    mapBaseView.clear()
                    
                    createCircle()
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
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool)
    {
        isTouchMap = true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        
            self.view.isUserInteractionEnabled = true
            self.mapBaseView.isUserInteractionEnabled = true
            lat = position.target.latitude
            long  = position.target.longitude
            self.marker.position = position.target
        
            //Getting Address
        UserDefaults.standard.set(self.lat, forKey:"createlatitude")
        UserDefaults.standard.set(self.long, forKey:"createlongitude")
        
        UserDefaults.standard.synchronize()
        
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.lat, longitude: self.long)
            geoCoder.reverseGeocodeLocation(location)
            {
                (placemarks, error) -> Void in
              
                if error == nil {
                    
                    
                        self.view.isUserInteractionEnabled = true
                        //self.mapBaseView.isUserInteractionEnabled = true
                        //
                        if self.check == true
                        {
                            
                        }
                        else
                        {
                            SVProgressHUD.show()
                        }
                }
                
                
                
            }
            
            
        
        
    }
    
    func updateCirclePosition()
    {
       
            self.view.isUserInteractionEnabled = true
            SVProgressHUD.show()
        
    }
    
    // Create Circle
    func createCircle()
    {
        //Add Circle to Map
        
        mapBaseView.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: lat,longitude: long),zoom:zoomvalue)
        
        //Add Marker
        let position = CLLocationCoordinate2DMake(lat, long)
        marker = GMSMarker(position: position)
        self.mapBaseView.delegate = self
        marker.map = self.mapBaseView
        marker.icon = self.imageWithImage(image: UIImage(named: "alertizen_icon.png")!, scaledToSize: CGSize(width:70, height:80))
    }
    //Resize Marker Image
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize,false,0.0)
        image.draw(in: CGRect(x:0,y:0,width:newSize.width,height:newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func dismissLoader()
    {
        SVProgressHUD.dismiss()
        areaTxtField.resignFirstResponder()
        self.view.isUserInteractionEnabled = true
        self.switchAction.isUserInteractionEnabled = true
       /* if (self.switchAction.tag != 4)
        {
            self.mapBaseView.isUserInteractionEnabled = true
        }*/
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
            
            
            if(self.lblEnterAddress.text == "Enter Address")
            {
                        UIAlertController.Alert(title: "", msg: "Please Enter Address", vc: self)
                }
                else
                {
                        
                                
                        _ =  Timer.scheduledTimer(timeInterval:0.5, target: self, selector: #selector(locationViewController.popToBack), userInfo: nil, repeats: false)
                               
                        
                            
                }
            
            
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
            distValueStr = "0.75"
        }
        else
        {
            distValueStr = "0.50"
        }
        SVProgressHUD.show()
        
        
    }
    
    @IBAction func btnCurrentLocationClick(sender:UIButton)
    {
        mapBaseView.clear()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            let status = CLLocationManager.authorizationStatus()
            if(status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.notDetermined)
            {
                acceptNotiView.isHidden = false
            }
            else
            {
                acceptNotiView.isHidden = true
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                
                lat = locationManager.location?.coordinate.latitude
                
                long = locationManager.location?.coordinate.longitude
                
                createCircle()
            }
        }
        else
        {
            
            UIAlertController.Alert(title: "", msg: "Location services are not enabled", vc: self)
           
        }
        
    }
    
    //MARK: TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        areaTextString = areaTxtField.text
        
        areaTxtField.text = ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        
    {
        checktextfield = true
        return true
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
        SVProgressHUD.show()
       
        
        return true
    }
    
    @IBAction func entrAdrsBtnClick(_ sender: UIButton)
    {
        if(areaTxtField.text? .isEqual(""))!
        {
            areaTxtField.text = areaTextString
        }
       
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func btnAlertNextClick(_ sender: Any)
    {
        //showSettingAlert()
    }
    
    @IBAction func btnAlertBackClick(_ sender: Any)
    {
        let _ = self.navigationController?.popViewController(animated: true)
      
    }
    
}

extension locationViewController: GMSAutocompleteViewControllerDelegate
{
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        print("Place name: ", place.formattedAddress)
        
        mapBaseView.clear()
        
        lat = place.coordinate.latitude
        long = place.coordinate.longitude
        
        lblEnterAddress.text = place.formattedAddress
        
        UserDefaults.standard.set(self.lblEnterAddress.text, forKey:"createAddress")
        UserDefaults.standard.synchronize()
        
        zoomvalue = 18
        
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
