//
//  InboxVC.swift
//  Alertizen
//
//  Created by Mind Roots Technologies on 18/11/16.
//  Copyright © 2016 Mind Roots Technologies. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

class InboxVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var messagesArray = NSMutableArray()
    
    @IBOutlet var viewNoMessages: UIView!
    
    var arrDeleteMsg = NSMutableArray()
    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet var imgNavEdit: UIImageView!
    
    @IBOutlet var btnNavEdit: UIButton!
    
    @IBOutlet var actionToolbar: UIToolbar!
    
    var isEditMode = false
    
    @IBOutlet var btnDeleteAll: UIButton!
    
    @IBOutlet var btnDelete: UIButton!
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
       
        super.viewDidLoad()
                
        refreshView()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: refreshInbox, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name: refreshInbox, object: nil)
    }
    
    func refreshView()
    {
        actionToolbar.isHidden = true
        self.tblView.rowHeight = UITableViewAutomaticDimension;
        self.tblView.estimatedRowHeight = 55;
        getMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnnextAction(_ sender: UIButton) -> Void
    {
        let vc = newViewController(nibName: "newViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton) -> Void
    {
        let vcIndex = self.navigationController?.viewControllers.index(where: { (viewController) -> Bool in
            
            if let _ = viewController as? CampusSelectionVC
            {
                return true
            }
            
            return false
        })
    
        let composeVC = self.navigationController?.viewControllers[vcIndex!] as! CampusSelectionVC
        
        let _ =  self.navigationController?.popToViewController(composeVC, animated: true)
    }
    
   // MARK:- Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.messagesArray.count>0
        {
            return self.messagesArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:InboxTableViewCell!  = tableView.dequeueReusableCell(withIdentifier: "Cell") as? InboxTableViewCell
        
        if  (cell==nil)
        {
            let nib:NSArray=Bundle.main.loadNibNamed("InboxTableViewCell", owner: self, options: nil)! as NSArray
            cell = nib.object(at: 0)as? InboxTableViewCell
        }
        
        cell.lblTitle.text = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "messageTitle") as! String?

        cell.lblAddress.text =  (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "address") as! String?
        
        let myDate = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "messageDate") as! String
        
        let dateNew = self.dateConvert(strDate: myDate)
        
        cell.lblDate.text =  dateNew as String
        
        cell.btnCheckBox.tag = indexPath.row
      
        cell.btnCheckBox.addTarget(self, action: #selector(self.btnMessageCheckBoxPressed), for: .touchUpInside)
        
        if arrDeleteMsg .contains(indexPath.row)
        {
            cell.btnCheckBox.setImage(UIImage(named: "deleteSelected_icon"), for: .normal)
        }
        else
        {
             cell.btnCheckBox.setImage(UIImage(named: "deleteUnselected_icon"), for: .normal)
        }
        if indexPath.row != 0
        {
            let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
            
            separatorView.backgroundColor = UIColor.gray
            
            cell.addSubview(separatorView)
        }
        
        return cell
        
    }
    
    func dateConvert(strDate : String) -> String
    {
        let dateString = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str : Date
        if let s = dateFormatter.date(from: dateString)
        {
            str = s
        }
        else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            str = dateFormatter.date(from: dateString)!
        }
        let date = str
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd hh:mm a"
        let dateString1 = dateFormatter1.string(from: date)
        return dateString1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if let isPolice = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "isPoliceSponsor") as? String
        {
            if isPolice == "1"
            {
                if let url = NSURL(string: ((messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "psLink") as! String?)!)
                {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            else
            {
                let vc = InboxMapViewController(nibName: "InboxMapViewController", bundle: nil)
                vc.lat = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "latitude") as! String?
                vc.long = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "longitude") as! String?
                vc.strTitle = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "messageTitle") as! String?
                vc.strAddress = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "address") as! String?
                let myDate = (messagesArray.object(at: indexPath.row) as AnyObject).value(forKey: "messageDate") as! String?
                let dateNew = self.dateConvert1(strDate: myDate!)
                vc.strDate = dateNew
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func dateConvert1(strDate : String) -> String {
        
        let dateString = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str : Date
        if let s = dateFormatter.date(from: dateString)
        {
            str = s
        }
        else
        {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            str = dateFormatter.date(from: dateString)!
        }
        let date = str
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM dd, yyyy hh:mm a"
        let dateString1 = dateFormatter1.string(from: date)
        return dateString1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let moc = self.getContext()
            let note = messagesArray.object(at: indexPath.row)
            moc.delete(note as! NSManagedObject)
            
            do {
                try moc.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            // Delete the row from the data source
            messagesArray.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle
    {
        if isEditMode
        {
            return .none
        }
        else
        {
            return .delete
        }
    }
    
    // MARK:- Database
    
    func getContext () -> NSManagedObjectContext
    {
        return Storage.shared.context
    }

    func saveAllMessagesDB(arr : [Dictionary<String, AnyObject>]) -> Void
    {
        let context =  self.getContext()
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "MessageEntity", in: context)
        
        for dict in arr
        {
            
            let managedObject = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObject.setValue(dict["title"], forKey: "messageTitle")
            
            managedObject.setValue(dict["address"], forKey: "address")
            
            managedObject.setValue(dict["latitude"], forKey: "latitude")
            
            managedObject.setValue(dict["longitude"], forKey: "longitude")
            
            managedObject.setValue(dict["msg_date"], forKey: "messageDate")
            
            managedObject.setValue(dict["messageText"], forKey: "messageText")
            
            managedObject.setValue(dict["is_police_sponsor"], forKey: "isPoliceSponsor")
            
            if let psLink = dict["ps_link"] as? String
            {
                managedObject.setValue(psLink, forKey: "psLink")
            }
            else
            {
                managedObject.setValue("", forKey: "psLink")
            }
            do {
                try context.save()
                print("saved!")
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
            }
            
        }
        
        self.FetchFromDB()
        
    }
    
    
    func FetchFromDB () {
        //create a fetch request, telling it about the entity
        
        arrDeleteMsg.removeAllObjects()
        
        self.messagesArray.removeAllObjects()
        
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        
        do {
            //go get the results
            let searchResults = try self.getContext().fetch(fetchRequest)
            
            //I like to check the size of the returned results!
            print ("num of results = \(searchResults.count)")
            
            self.messagesArray = NSMutableArray(array: searchResults)
            
            print(self.messagesArray)
            
            let  mutablearray  =  NSMutableArray(array:messagesArray.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
            
            self.messagesArray = NSMutableArray(array: mutablearray)
      
            if self.messagesArray.count>0
            {
                
                tblView.isHidden = false
                viewNoMessages.isHidden = true
                imgNavEdit.isHidden = false
                btnNavEdit.isUserInteractionEnabled = true
                tblView.reloadData()
                hud.removeFromSuperview()
            
            }
            else
            {
                tblView.isHidden = true
                viewNoMessages.isHidden = false
                imgNavEdit.isHidden = true
                btnNavEdit.isUserInteractionEnabled = false
                hud.removeFromSuperview()
            }
            
        } catch
        {
            print("Error with request: \(error)")
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
        FetchFromDB()
    }
    
    
    func getMessages() -> Void
    {
        hud.show(true)
        hud.frame = self.view.frame
        hud.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.50)
        hud.color = UIColor.clear
        self.view.addSubview(hud)
        
        let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
        print(detail)
        let detail_Dict = ((detail["userDetails"] as! NSDictionary)["userId"] as! String)
        let phone_Dict = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
        let dictUserInfo = ["userId":detail_Dict,"phone":phone_Dict,"secure_token":"CMPS-GotinMsgb78x"] as [String : String]
        
        print(dictUserInfo)
        
        WebService.sharedInstance.postMethodWithParams(strURL: "inbox_msg.php" , dict: dictUserInfo as NSDictionary, completionHandler: { (dictResponse) in
            
            print(dictResponse)
            
            if (dictResponse.object(forKey: "success") != nil)
            {
                OperationQueue.main.addOperation
                    {
                        if (dictResponse.object(forKey: "new_message") as! String == "true")
                        {
                            let arrInbox = dictResponse.value(forKey: "messageDetails") as! [Dictionary<String, AnyObject>]
                            
                            self.saveAllMessagesDB(arr: arrInbox)
                        }
                        else
                        {
                            self.FetchFromDB()
                        }
                  }
            }
            else
            {
                OperationQueue.main.addOperation
                {
                    self.FetchFromDB()
                }
            }
            
        }, failure:{ (errorMsg) in
            
            UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
            
            hud.removeFromSuperview()
        })
    }

    
    @IBAction func btnProfileClick(_ sender: UIButton) -> Void
    {
        
        let editProfile = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        self.navigationController?.pushViewController(editProfile, animated: false)
        
    }
    
    
    @IBAction func btnEditClick(_ sender: Any)
    {
        
        arrDeleteMsg.removeAllObjects()
        
        tblView.reloadData()
        
        resetVC()
        
    }
    
    
    func resetVC() -> Void
    {
        if isEditMode == false
        {
            
            isEditMode = true
            tblView.setEditing(true, animated: true)
            btnNavEdit.setTitle("Cancel",for: .normal)
            imgNavEdit.image=UIImage(named: "")
            actionToolbar.isHidden = false
            btnDelete.isEnabled = false
            btnDelete.alpha = 0.7
            
        }
        else
        {
            
            isEditMode = false
            tblView.setEditing(false, animated: true)
            btnNavEdit.setTitle("",for: .normal)
            imgNavEdit.image=UIImage(named: "edit_icon")
            actionToolbar.isHidden = true
            
        }
    }
    
    func btnMessageCheckBoxPressed(_ sender: UIButton)
    {
        
        let index = sender.tag
        
        if arrDeleteMsg .contains(index)
        {
            arrDeleteMsg.remove(index)
            sender.setImage(UIImage(named: "deleteUnselected_icon"), for: .normal)
        }
        else
        {
            arrDeleteMsg.add(index)
            sender.setImage(UIImage(named: "deleteSelected_icon"), for: .normal)

        }
        if arrDeleteMsg.count>0
        {
            btnDelete.isEnabled = true
            btnDelete.alpha = 1.0
        }
        else
        {
            btnDelete.isEnabled = false
            btnDelete.alpha = 0.7
        }
        print(arrDeleteMsg)
        
    }
    
    @IBAction func btnDeleteAllClick(_ sender: Any)
    {
        resetVC()
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        self.deleteRequest(fetchReq:fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
    }
    
    @IBAction func btnDeleteClick(_ sender: Any)
    {
        
        for index in arrDeleteMsg
        {
            
            let moc = self.getContext()
            let note = messagesArray.object(at: index as! Int)
            moc.delete(note as! NSManagedObject)
            
            do
            {
                try moc.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        }
        
        resetVC()
        
        FetchFromDB()
        
    }
}
