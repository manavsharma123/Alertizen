//
//  AppDelegate.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit
import CoreLocation
import AirshipKit
import GoogleMobileAds
import FirebaseCore
import FirebaseAnalytics
let hud = MBProgressHUD()

   var channelId : String?

   let notification = NSNotification.Name(rawValue: "callNotificationCenter")

   let refreshInbox = NSNotification.Name(rawValue: "refreshInboxCenter")


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UARegistrationDelegate,CLLocationManagerDelegate,UAPushNotificationDelegate
{
    var window: UIWindow?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var login : Bool = false
   
    var lat : Double!
   
    var long : Double!
    
    var latOld : Double!
   
    var longOld : Double!
    
    let bgTask = BackgroundTask()

    var navigationController = UINavigationController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        //Google Mobile Ad // live
       // GADMobileAds.configure(withApplicationID: "ca-app-pub-7570537979095777~5950385518")
        
            FirebaseApp.configure()
        
        // test key from 786 acc
//        ca-app-pub-6849765509322868~8073098239
        
        GADMobileAds.configure(withApplicationID:"ca-app-pub-6229411317924470~5791872641")
        
        //Google Map Key
        GMSServices.provideAPIKey("AIzaSyDJeNU_6_ayoUBvMvjnl-XidNoSH5Xtym4")
        
        //Google Places Key
        GMSPlacesClient.provideAPIKey("AIzaSyB1Cz1mwEqzcjxks0BkjWOfKD5BQQGsyC8")
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        if (UserDefaults.standard.bool(forKey: "Login") == false) {
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "createProfile")
            navigationController = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "campus")
            navigationController = UINavigationController(rootViewController: viewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        //Abhi
         self.pushNotificationUrban()
        
        // Testing Mode
       // channelId =  "5c7464c3-f9d6-4449-991dgsdgdsg666-232"
        
        let dic = ["key":"1"]
        
        UserDefaults.standard.set(dic, forKey:"getMapInfoDetails")
    
        let dic1 = ["key":"1"]
        
        UserDefaults.standard.set(dic1, forKey:"getMapUpdateDetails")
        
        UserDefaults.standard.set("3", forKey:"switchSet")
        
        UserDefaults.standard.set("3", forKey:"UpdateswitchSet")
        
        UserDefaults.standard.set("0", forKey: "phoneVerify")
        
        UserDefaults.standard.set("0", forKey: "codeentered")
        
        // Testing Mode
      // let uid = "4A21542B-101C-4BA8-8AD8-B3DBE86B9236"
        
     let uid = UIDevice.current.identifierForVendor!.uuidString
        
        UserDefaults.standard.setValue(uid, forKey: "UID")
        
        UserDefaults.standard.synchronize()
    
        return true
    }
    
    
    func pushNotificationUrban()
    {
        let config = UAConfig.default()
        config.messageCenterStyleConfig = "UAMessageCenterDefaultStyle"
        
        UAirship.takeOff(config)
       
        UAirship.push()?.userPushNotificationsEnabled = true
       
        UAirship.push().notificationOptions = [.alert, .badge, .sound]
      
        UAirship.push().isAutobadgeEnabled = true
       
        UAirship.push().resetBadge()
      
        UAirship.push().pushNotificationDelegate = self
       
        UAirship.push().registrationDelegate = self
       
        if let newChannelID : String = UAirship.push().channelID {
            
           channelId = newChannelID
        }
    }
    
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL?,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }
    
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL?,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    
    // MARK:- Notification Delegates
    func receivedBackgroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)
    {
        // Application received a background notification
        print("The application received a background notification");
        
        // Call the completion handler
        completionHandler(.noData)
    }
    
    func receivedForegroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping () -> Swift.Void)
    {
        // Application received a foreground notification
        print("The application received a foreground notification");
        
        // iOS 10 - let foreground presentations options handle it
        if (ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)))
        {
            NotificationCenter.default.post(name:refreshInbox, object: nil)
            completionHandler()
            return
        }
     }
    
    func receivedNotificationResponse(_ notificationResponse: UANotificationResponse, completionHandler: @escaping () -> Swift.Void)
    {
        print("The user selected the following action identifier:%@", notificationResponse);
        
        UAirship.push().resetBadge()

        if let dict = notificationResponse.notificationContent.notificationInfo as? [String: AnyObject] {
            
            if (UserDefaults.standard.bool(forKey: "Login") == true)
            {
                
                if let is_police_sponsor = dict["is_police_sponsor"] as? String
                {
                    
                    if is_police_sponsor == "0"
                    {
                        
                        let vc = InboxMapViewController(nibName: "InboxMapViewController", bundle: nil)
                        vc.lat = dict["latitude"] as! String?
                        vc.long = dict["longitude"] as! String?
                        vc.strTitle = dict["title"] as! String?
                        vc.strAddress = dict["msg_address"] as! String?
                        let myDate = dict["msg_date"] as! String?
                        let dateNew = self.dateConvert1(strDate: myDate!)
                        vc.strDate =  dateNew
                        navigationController.pushViewController(vc, animated: false)
                        
                    }
                    
                }

            }
            
        }
        
        completionHandler()
    }
    
    func dateConvert1(strDate : String) -> String {
        
        let dateString = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        ///let s = dateFormatter.date(from: dateString)
        
        guard let s = dateFormatter.date(from: dateString)
            else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let s = dateFormatter.date(from: dateString)
            let date = s
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateString1 = dateFormatter1.string(from: date!)
            return dateString1
        }
        
        //CONVERT FROM NSDate to String
        
        let date = s
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd, yyyy hh:mm a"
        let dateString1 = dateFormatter1.string(from: date)
        return dateString1
        
    }

    @available(iOS 10.0, *)
    func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions
    {
        return [.alert, .sound]
    }

    // MARK:- Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let myLatLong = locations[0]
        
        lat = myLatLong.coordinate.latitude
        
        long = myLatLong.coordinate.longitude
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func dismissLoader()
    {
        if CLLocationManager.locationServicesEnabled()
        {
                if lat != nil && long != nil
                {
                    let newLoc = CLLocation(latitude: latOld, longitude: longOld)
                    let rismanPlaza = CLLocation(latitude: lat, longitude: long)
                    let distanceMeters = newLoc.distance(from: rismanPlaza)
                    let distanceKM = distanceMeters / 1000
                    let feet = distanceKM * 3280.84
                    print(feet)
                    if feet > 500
                    {
                        latOld = lat
                        
                        longOld = long
                    
                        UserDefaults.standard.set(latOld, forKey:"latitudeOld")
                        
                        UserDefaults.standard.set(longOld, forKey:"longitudeOld")
                        
                    let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
                    
                    let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
                    
                    let phnNo = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
                    
                    var dictUserInfo :  [String : AnyObject]
                   
                    dictUserInfo = ["userId":detail_Dict as AnyObject,"mon_area":"4" as AnyObject,"mon_name":"Mobile Monitoring" as AnyObject,"address":"Enter Address" as AnyObject,"distance":"0.095" as AnyObject,"latitude":lat as AnyObject,"longitude":long as AnyObject,"status":"1" as AnyObject,"phone":phnNo as AnyObject,"device_token":channelId! as AnyObject,"and_channel_id":channelId! as AnyObject,"device_type":"1" as AnyObject,"secure_token":"CMPS-vncSx3ghGaW" as AnyObject]
                    WebService.sharedInstance.postMethodWithParams(strURL: "update_area.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                        { (dictReponse) in
                            
                            print(dictReponse)
                            
//                            if (dictReponse.object(forKey: "success") != nil)
//                            {
//                                let notification = UILocalNotification()
//                                notification.alertBody = "\(self.lat)-\(self.long)"
//                                notification.soundName = "Default"
//                                UIApplication.shared.presentLocalNotificationNow(notification)
//                                
//                            }
                            
                    }, failure:{ (errorMsg) in
                        print(errorMsg)
                    })
                }
    
            }
        }
    }
    
    func callAgain() -> Void
    {
        /// print("...callAgain... ")
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.startUpdatingLocation()
       
        if let strLat =  UserDefaults.standard.value(forKey: "latitudeOld") as? Double
        {
            latOld = strLat
        }
        if let strLong =  UserDefaults.standard.value(forKey: "longitudeOld") as? Double
        {
            longOld = strLong
        }
        if (UserDefaults.standard.bool(forKey: "mobileMontOn") == true)
        {
            dismissLoader()
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
        bgTask.startBackgroundTasks(10, target: self, selector: #selector(callAgain))
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        bgTask.stop()
        
        UAirship.push().resetBadge()
        
        NotificationCenter.default.post(name:notification, object: nil)
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        bgTask.stop()

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // self.saveContext()
    }

    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Alertizen")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

}
