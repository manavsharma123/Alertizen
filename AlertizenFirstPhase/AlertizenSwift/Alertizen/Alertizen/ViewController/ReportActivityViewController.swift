//
//  ReportActivityViewController.swift
//  Alertizen
//
//  Created by Mac OSX on 23/05/17.
//  Copyright © 2017 Mind Roots Technologies. All rights reserved.
//

import UIKit
struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

let IS_IPHONE  = UIDevice.current.userInterfaceIdiom == .phone

let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0

let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0

let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0

let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0

let IS_IPHONE_7          = IS_IPHONE_6

let IS_IPHONE_7P         = IS_IPHONE_6P

class ReportActivityViewController: UIViewController ,UITextFieldDelegate,UIActionSheetDelegate ,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate, UIPickerViewDelegate {
    
    var picker_State: UIPickerView! = UIPickerView()
    
    var viewDate = UIView()
    
    var check = Bool()
    
    @IBOutlet var scroll_View:UIScrollView?
    
    @IBOutlet var text_suspiciousActivity: UITextView?
    
    @IBOutlet var text_enterAddress: UITextField?
    
    @IBOutlet var text_namePerson: UITextField?
    
    @IBOutlet var text_vechileDesc: UITextField?
    
    @IBOutlet var text_busyTimeofday: UITextField?
    
    @IBOutlet var text_busyDayofweek: UITextField?
    
    @IBOutlet var text_narcotics: UITextField?
    
    @IBOutlet var text_yourName: UITextField?
    
    @IBOutlet var text_yournumber: UITextField?
    
    @IBOutlet var btn_submit: UIButton?
    
    var array_week = NSMutableArray()
    
    @IBOutlet var table_weekDay:UITableView?
    
    var array_Zip = NSArray()
    
    var array_drugTraffking = NSMutableArray()
    
    var dic_values = NSDictionary()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UserDefaults.standard.set("", forKey:"createlatitude")
        UserDefaults.standard.set("", forKey:"createlongitude")
        
        UserDefaults.standard.set("", forKey:"createAddress")
        UserDefaults.standard.synchronize()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReportActivityViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    
    
    //Calls this function when the tap is recognized.
   
        //self.get_DropdownValues()
        
        check = true
        
        text_suspiciousActivity?.delegate = self
        
        text_suspiciousActivity?.text = "Description of the suspicious activity PLEASE BE SPECIFIC"
        
        text_suspiciousActivity?.textColor = UIColor.black
        
        //scroll_View?.contentSize = CGSize(width: self.view.frame.size.width, height:(btn_submit?.frame.origin.y )! + (btn_submit?.frame.height)! + 30)
        
       // text_suspiciousActivity?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        
        
        text_enterAddress?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_namePerson?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_vechileDesc?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_busyTimeofday?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_busyDayofweek?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_narcotics?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_yourName?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        text_yournumber?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        
        
        // Do any additional setup after loading the view.
    }
    

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        text_suspiciousActivity?.resignFirstResponder()
        text_enterAddress?.resignFirstResponder()
     
        text_namePerson?.resignFirstResponder()
        text_vechileDesc?.resignFirstResponder()
        text_narcotics?.resignFirstResponder()
        text_yourName?.resignFirstResponder()
        text_yournumber?.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let address = UserDefaults.standard.value(forKey: "createAddress") as! String
        text_enterAddress?.text = address
    }
    override func viewDidAppear(_ animated: Bool) {
        
        scroll_View?.contentSize = CGSize(width: self.view.frame.size.width, height:(btn_submit?.frame.origin.y )! + (btn_submit?.frame.height)! + 30)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) -> Void {
        

        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        viewDate.isHidden = true
        
        if text_suspiciousActivity?.textColor == UIColor.black {
            text_suspiciousActivity?.text = ""
            text_suspiciousActivity?.textColor = UIColor.black
        }
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: -120, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if text_suspiciousActivity?.text == "" {
            
            text_suspiciousActivity?.text = "Description of the suspicious activity PLEASE BE SPECIFIC"
            text_suspiciousActivity?.textColor = UIColor.black
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        
        
        if textField == text_namePerson
        {
            text_namePerson?.placeholder = "Name of the person"
        }
        
        if textField == text_vechileDesc
        {
            text_vechileDesc?.placeholder = "Description of the vehicle"
        }
        if textField == text_narcotics
        {
            text_narcotics?.placeholder = "Please Enter"
        }
        if textField == text_yourName
        {
            text_yourName?.placeholder = "Your Name"
        }
        if textField == text_yournumber
        {
            text_yournumber?.placeholder = "Your Phone Number"
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        viewDate.isHidden = true
        
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: -175, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
        if  textField == text_yournumber {
            
            textField.keyboardType = .numberPad
            
            self.addDoneButton(textfield: textField)
            
        }
        else
        {
            let toolBar = UIToolbar()
            
            toolBar.barStyle = UIBarStyle.default
            
            textField.inputAccessoryView = toolBar
            
            textField.keyboardType = .default
            
        }
        
        
        if textField == text_namePerson
        {
            text_namePerson?.placeholder = ""
        }
        
        if textField == text_vechileDesc
        {
            text_vechileDesc?.placeholder = ""
        }
        if textField == text_narcotics
        {
            text_narcotics?.placeholder = ""
        }
        if textField == text_yourName
        {
            text_yourName?.placeholder = ""
        }
        if textField == text_yournumber
        {
            text_yournumber?.placeholder = ""
        }

    
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        check = true
        
        if textField == text_yournumber
        {
            var strText: String? = textField.text
            if strText!.characters.count < 12
            {
                
                if strText == nil {
                    strText = ""
                }
                strText = strText?.replacingOccurrences(of: "", with: "-", options: .literal, range: nil)
        
                if strText!.characters.count < 5 && strText!.characters.count > 1 && strText!.characters.count % 3 == 0 && string != "" {
                    textField.text = "\(textField.text!)-\(string)"
                    return false
                }
                else if strText!.characters.count == 7 &&  string != "" {
                  textField.text = "\(textField.text!)-\(string)"
                  return false
                }
                else if (textField.text!.characters.count == 11)
                {
                    if string == ""
                    {
                        check = true
                    }
                    else
                    {
                        textField.text = "\(textField.text!)\(string)"
                        textField.resignFirstResponder()
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
                            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        }, completion: nil)
                        
                        return false
                    }
                    
                    
                }

                
            }
            else
            {
              
                if string == ""
                {
                    check = true
                }
                else
                {
                    check = false
                }
                if (textField.text!.characters.count == 12)
                {
                    if string == ""
                    {
                        check = true
                    }
                    else
                    {
                        textField.resignFirstResponder()
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
                            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        }, completion: nil)
                        
                        return true
                    }
                }
            }
        }
        return check
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       
       
        
        if textField == text_namePerson{
            text_vechileDesc?.becomeFirstResponder()
        }
            
        else if textField == text_vechileDesc {
            text_narcotics?.becomeFirstResponder()
        }
            
        else if textField == text_narcotics {
            text_yourName?.becomeFirstResponder()
        }
        else if textField == text_yourName{
            text_yournumber?.becomeFirstResponder()
        }
        
        else if textField == text_yournumber{
            text_yournumber?.resignFirstResponder()
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
        }
      
        
        return true
    }
    

    
    func addDoneButton(textfield:UITextField)
    {
        
        let keyboardToolbar = UIToolbar()
        
        keyboardToolbar.sizeToFit()
        
        keyboardToolbar.backgroundColor = UIColor.lightGray
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self, action: #selector(toolBarDoneClick))
        
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        
        textfield.inputAccessoryView = keyboardToolbar
        
    }
    
    func toolBarDoneClick()
    {
        text_yournumber?.resignFirstResponder()
        
        text_enterAddress?.resignFirstResponder()
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    // MARK: - Table Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array_week.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.showsVerticalScrollIndicator = false
        
        let cell =  UITableViewCell()
        
        cell.selectionStyle = .none
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        
        label.textAlignment = .center
        
        label.text = self.array_week.object(at: indexPath.row) as? String
        
        label.font = UIFont(name: "Avenir-Book", size: 14.0)
        
        cell.addSubview(label)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         viewDate.isHidden = true
        
        
        if tableView.tag == 1290
        {
            text_busyDayofweek?.text = self.array_week.object(at: indexPath.row) as? String
        }
        else
        {
            text_busyTimeofday?.text = self.array_week.object(at: indexPath.row) as? String
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReportActivityViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Date Picker
    func addDatePicker() -> Void {
        
        viewDate.removeFromSuperview()
        
        viewDate = UIView()
        
        viewDate.frame = CGRect(x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width, height: 250)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        datePickerView.frame = CGRect(x: 0, y:50, width: self.view.frame.size.width, height: 200)
        
        datePickerView.addTarget(self, action: #selector(datePickerValuechange), for: UIControlEvents.valueChanged)
        
        viewDate.addSubview(datePickerView)
        
        viewDate.backgroundColor = UIColor.white
        
        let viewTitle = UIView()
        
        viewTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        viewTitle.backgroundColor = UIColor(red: 112/255.0, green:181/255.0, blue: 255/255.0, alpha: 1.0)
        
        viewDate.addSubview(viewTitle)
        
        let buttonDone = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        
        buttonDone.setTitle("Done", for: .normal)
        
        buttonDone.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
        
        buttonDone.setTitleColor(UIColor.black, for: .normal)
        
        buttonDone.contentHorizontalAlignment = .center
        
        buttonDone.addTarget(self, action: #selector(buttondoneClick), for: .touchUpInside)
        
        viewDate.addSubview(buttonDone)
        
        self.view.addSubview(viewDate)
        
    }
    
    
    func addpicker() -> Void {
        
        viewDate.removeFromSuperview()
        
        array_week = NSMutableArray()
        
        array_week.add("Sunday")
        
        array_week.add("Monday")
        
        array_week.add("Tuesday")
        
        array_week.add("Wednesday")
        
        array_week.add("Thursday")
        
        array_week.add("Friday")
        
        array_week.add("Saturday")
        
        array_week.add("Every Day")
        
        viewDate = UIView()
            
        viewDate.frame = CGRect(x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width, height: 250)
        
        
        table_weekDay = UITableView()
        
        table_weekDay?.frame = CGRect(x: 0, y:50, width: self.view.frame.size.width, height: 200)
        
        table_weekDay?.tag = 1290
        
        table_weekDay?.dataSource = self
        
        table_weekDay?.delegate = self
        
        viewDate.addSubview(table_weekDay!)
        
        viewDate.backgroundColor = UIColor.white
            
        let viewTitle = UIView()
            
        viewTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
            
        viewTitle.backgroundColor = UIColor(red: 112/255.0, green:181/255.0, blue: 255/255.0, alpha: 1.0)
            
        viewDate.addSubview(viewTitle)
            
        let buttonDone = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
            
        buttonDone.setTitle("Done", for: .normal)
            
        buttonDone.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
            
        buttonDone.setTitleColor(UIColor.black, for: .normal)
            
        buttonDone.contentHorizontalAlignment = .center
            
        buttonDone.addTarget(self, action: #selector(buttondoneClick), for: .touchUpInside)
            
        viewDate.addSubview(buttonDone)
            
        self.view.addSubview(viewDate)
            
        
    }
    
    func addpickerTime() -> Void {
        
        array_week = NSMutableArray()
        
        array_week.add("Morning - 6:00 AM - Noon")
        
        array_week.add("Afternoon - Noon to 6:00 PM")
        
        array_week.add("Evening - 6:00 PM to Midnight")
        
        array_week.add("Night - Midnight to 6:00 AM.")
        
        array_week.add("No Consistent Time")
        
        viewDate.removeFromSuperview()
        
        viewDate = UIView()
        
        viewDate.frame = CGRect(x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width, height: 250)
        
        table_weekDay = UITableView()
        
        table_weekDay?.frame = CGRect(x: 0, y:50, width: self.view.frame.size.width, height: 200)
        
        table_weekDay?.tag = 1291
        
        table_weekDay?.dataSource = self
        
        table_weekDay?.delegate = self
        
        viewDate.addSubview(table_weekDay!)
        
        viewDate.backgroundColor = UIColor.white
        
        let viewTitle = UIView()
        
        viewTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        viewTitle.backgroundColor = UIColor(red: 112/255.0, green:181/255.0, blue: 255/255.0, alpha: 1.0)
        viewDate.addSubview(viewTitle)
        
        let buttonDone = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        
        buttonDone.setTitle("Done", for: .normal)
        
        buttonDone.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
        
        buttonDone.setTitleColor(UIColor.black, for: .normal)
        
        buttonDone.contentHorizontalAlignment = .center
        
        buttonDone.addTarget(self, action: #selector(buttondoneClick), for: .touchUpInside)
        
        viewDate.addSubview(buttonDone)
        
        self.view.addSubview(viewDate)
        
        
    }
    
    func datePickerValuechange(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        text_busyTimeofday?.text = dateFormatter.string(from: sender.date)
        
    }
    
    func datePickerValuechange1(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE"
        
        text_busyDayofweek?.text = dateFormatter.string(from: sender.date)
        
    }
    
    func buttondoneClick(sender: UIButton!) {
        
        viewDate.isHidden = true
        
    }
    
   
    @IBAction func buttonTimeClick(sender: UIButton!) {
        
        
        self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        self.addpickerTime()
        text_suspiciousActivity?.resignFirstResponder()
      
        text_enterAddress?.resignFirstResponder()
        text_namePerson?.resignFirstResponder()
        text_vechileDesc?.resignFirstResponder()
        text_narcotics?.resignFirstResponder()
        text_yourName?.resignFirstResponder()
        text_yournumber?.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    
    @IBAction func buttonWeekClick(sender: UIButton!) {
        
           self.view.gestureRecognizers?.forEach(self.view.removeGestureRecognizer)
        self.addpicker()
       
        text_suspiciousActivity?.resignFirstResponder()
        text_enterAddress?.resignFirstResponder()
        
        text_namePerson?.resignFirstResponder()
        text_vechileDesc?.resignFirstResponder()
        text_narcotics?.resignFirstResponder()
        text_yourName?.resignFirstResponder()
        text_yournumber?.resignFirstResponder()
     
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    // MARK: - Picker 
    @IBAction func enteraddress_Click(_ sender: UIButton) -> Void {
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
        
        text_suspiciousActivity?.resignFirstResponder()
        text_enterAddress?.resignFirstResponder()
        
        text_namePerson?.resignFirstResponder()
        text_vechileDesc?.resignFirstResponder()
        text_narcotics?.resignFirstResponder()
        text_yourName?.resignFirstResponder()
        text_yournumber?.resignFirstResponder()
        let vc = locationViewController(nibName: "locationViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
   
    @IBAction func city_Click(_ sender: UIButton) -> Void {
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
        
        text_suspiciousActivity?.resignFirstResponder()
        
        text_enterAddress?.resignFirstResponder()
        text_namePerson?.resignFirstResponder()
        text_vechileDesc?.resignFirstResponder()
        text_narcotics?.resignFirstResponder()
        text_yourName?.resignFirstResponder()
        text_yournumber?.resignFirstResponder()
        
        
        viewDate.removeFromSuperview()
        
        viewDate = UIView()
        
        viewDate.frame = CGRect(x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width, height: 250)
        
        
        picker_State?.frame = CGRect(x: 0, y:50, width: self.view.frame.size.width, height: 200)
        
        // picker_State?.dataSource = self
        
        picker_State?.delegate = self
        picker_State?.tag = 200001
        viewDate.addSubview(picker_State!)
        
        viewDate.backgroundColor = UIColor.white
        
        let viewTitle = UIView()
        
        viewTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        viewTitle.backgroundColor = UIColor(red: 0/255, green:0/255, blue: 255/255, alpha: 1.0)
        
        viewDate.addSubview(viewTitle)
        
        let buttonDone = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        
        buttonDone.setTitle("Done", for: .normal)
        
        buttonDone.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
        
        buttonDone.setTitleColor(UIColor.black, for: .normal)
        
        buttonDone.contentHorizontalAlignment = .center
        
        buttonDone.addTarget(self, action: #selector(buttondoneClick), for: .touchUpInside)
        
        viewDate.addSubview(buttonDone)
        
        self.view.addSubview(viewDate)
        
    }
    
    @IBAction func state_Click(_ sender: UIButton) -> Void {
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
     
        text_suspiciousActivity?.resignFirstResponder()
       
        text_enterAddress?.resignFirstResponder()
        text_namePerson?.resignFirstResponder()
        text_vechileDesc?.resignFirstResponder()
        text_narcotics?.resignFirstResponder()
        text_yourName?.resignFirstResponder()
        text_yournumber?.resignFirstResponder()
        
        viewDate.removeFromSuperview()
        
        viewDate = UIView()
        
        viewDate.frame = CGRect(x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width, height: 250)
        
            
        picker_State?.frame = CGRect(x: 0, y:50, width: self.view.frame.size.width, height: 200)
        
       // picker_State?.dataSource = self
        
        picker_State?.delegate = self
        picker_State?.tag = 200000
        viewDate.addSubview(picker_State!)
        
        viewDate.backgroundColor = UIColor.white
        
        let viewTitle = UIView()
        
        viewTitle.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        
        viewTitle.backgroundColor = UIColor(red: 0/255, green:0/255, blue: 255/255, alpha: 1.0)
        
        viewDate.addSubview(viewTitle)
        
        let buttonDone = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        
        buttonDone.setTitle("Done", for: .normal)
        
        buttonDone.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
        
        buttonDone.setTitleColor(UIColor.black, for: .normal)
        
        buttonDone.contentHorizontalAlignment = .center
        
        buttonDone.addTarget(self, action: #selector(buttondoneClick), for: .touchUpInside)
        
        viewDate.addSubview(buttonDone)
        
        self.view.addSubview(viewDate)
        
    }
    
    
    

    
        @IBAction func btn_SideClick(_ sender: UIButton) -> Void
        {
        
            sender.isSelected = !sender.isSelected
            
            if(sender.isSelected == true)
            {
                sender.setImage(UIImage(named:"checkedbl"), for: UIControlState.normal)
                  array_drugTraffking.add("Side")
                
            }
            else
            {
                sender.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
              array_drugTraffking.remove("Side")
            }
            let stringRepresentation = array_drugTraffking.componentsJoined(by: ",")
            print(stringRepresentation)
        }
    
        @IBAction func btn_BackClick(_ sender: UIButton) -> Void
        {
            sender.isSelected = !sender.isSelected
            
            if(sender.isSelected == true)
            {
                sender.setImage(UIImage(named:"checkedbl"), for: UIControlState.normal)
                array_drugTraffking.add("Back")
            }
            else
            {
                sender.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
                 array_drugTraffking.remove("Back")
            }
        }

    
        @IBAction func btn_BasementClick(_ sender: UIButton) -> Void
        {
        
            sender.isSelected = !sender.isSelected
            
            if(sender.isSelected == true)
            {
                sender.setImage(UIImage(named:"checkedbl"), for: UIControlState.normal)
                 array_drugTraffking.add("Basement")
            }
            else
            {
                sender.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
                array_drugTraffking.remove("Basement")
            }
        }

        @IBAction func btn_FrontClick(_ sender: UIButton) -> Void
        {
    
            sender.isSelected = !sender.isSelected
            
            if(sender.isSelected == true)
            {
                sender.setImage(UIImage(named:"checkedbl"), for: UIControlState.normal)
                array_drugTraffking.add("Front")
            }
            else
            {
                sender.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
                array_drugTraffking.remove("Front")
            }
            
        }
    
     func check_Vakidation() -> Void {
     
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .curveEaseOut, .curveEaseInOut], animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)

        
        if text_suspiciousActivity?.text == "Description of the suspicious activity PLEASE BE SPECIFIC"{
            
            let alert = UIAlertController(title: "Alert", message: "Enter Description of Suspicious Activity", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        
       
        
        
        guard let text_address = text_enterAddress?.text, !text_address.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Address of Activity", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let text_namePerson = text_namePerson?.text, !text_namePerson.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Name of Person(s) Involved", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let text_vechileDesc = text_vechileDesc?.text, !text_vechileDesc.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Description of Vehicle", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        guard let text_busyTimeofday = text_busyTimeofday?.text, !text_busyTimeofday.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Select Busiest Time of Day", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        guard let text_busyDayofweek = text_busyDayofweek?.text, !text_busyDayofweek.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Select Busiest Day of Week", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let text_narcotics = text_narcotics?.text, !text_narcotics.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Type of Narcotic Used", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        guard let text_yourName = text_yourName?.text, !text_yourName.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Your Name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        guard let text_yournumber = text_yournumber?.text, !text_yournumber.isEmpty else {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Your Phone Number", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        let whitespaceSet = CharacterSet.whitespaces
        
        
        if text_address.trimmingCharacters(in: whitespaceSet).isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Valid Address of Activity", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
        
        if text_namePerson.trimmingCharacters(in: whitespaceSet).isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Valid Name of Person(s) Involved", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
        
        if text_vechileDesc.trimmingCharacters(in: whitespaceSet).isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Valid Description of Vehicle", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
       
       
        if text_narcotics.trimmingCharacters(in: whitespaceSet).isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Valid Type of Narcotic Used", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
        if text_yourName.trimmingCharacters(in: whitespaceSet).isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Your Valid Name", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
        if text_yournumber.trimmingCharacters(in: whitespaceSet).isEmpty {
            
            let alert = UIAlertController(title: "Alert", message: "Enter Your Valid Phone Number", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
        }
        if array_drugTraffking.count == 0
        {
            let alert = UIAlertController(title: "Alert", message: "Select doors used by Customers", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        else
        {
            self.submit_api()
        }
        
    }
    
    @IBAction func btn_SubmitClick(_ sender: UIButton) -> Void
    {
       self.check_Vakidation()
        //self.submit_api()
    }
    // MARK: - get drop-down Values
    func submit_api() -> Void
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
            
            let stringRepresentation = array_drugTraffking.componentsJoined(by: ",")
         
            let lat = UserDefaults.standard.value(forKey: "createlatitude") as! Double
            
            let long = UserDefaults.standard.value(forKey: "createlongitude") as! Double
            
            let address = UserDefaults.standard.value(forKey: "createAddress") as! String
            
            let udid = UserDefaults.standard.value(forKey: "UID")

             let detail : NSDictionary = UserDefaults.standard.value(forKey:"getUserDetails") as! NSDictionary
            let phone = ((detail["userDetails"] as! NSDictionary)["phone"] as! String)
            
            let dictUserInfo : [String: String] =  ["description":(text_suspiciousActivity?.text)!,"house_no":"","street_name":"","city":"" ,"state":"","zip":"","name_person":(text_namePerson?.text)!,"desc_vehicle":(text_vechileDesc?.text)!,"drug_trafficking":stringRepresentation,"busiest_time":(text_busyTimeofday?.text)!,"busiest_day":(text_busyDayofweek?.text)!,"type_of_narcotics":(text_narcotics?.text)!,"your_name":(text_yourName?.text)!,"your_phone":(text_yournumber?.text)!,"address":address,"latitude":String(lat),"longitude":String(long),"phone":phone,"UU_ID":udid as! String,"userid": channelId!,"secure_token":"CMPS-LiceOpToDne"]
            
            print(dictUserInfo)
            
            WebService.sharedInstance.postMethodWithParams(strURL: "send_to_police.php", dict: dictUserInfo as NSDictionary, completionHandler:
                { (dictReponse) in
                        
                    print(dictReponse)
                  
                    OperationQueue.main.addOperation
                    {
                        // UIAlertController.Alert(title: "Alert", msg:  , vc: self)
                        let alert = UIAlertController(title: "If this is an emergency, call 911.", message: "Thank you for submitting this information.Please be aware,it may take weeks or longer to get the necessary evidence so a search warrant can be obtained.Please have patience.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                            switch action.style{
                                
                                
                            case .default:
                                print("default")
                                let _ = self.navigationController?.popViewController(animated: true)
                                
                                self.view.isUserInteractionEnabled = true
                                
                            case .cancel:
                                print("cancel")
                                let _ = self.navigationController?.popViewController(animated: true)
                                
                                self.view.isUserInteractionEnabled = true
                                
                            case .destructive:
                                print("destructive")
                            }
                        }))
                        
                        self.present(alert, animated: true, completion: nil)

                        hud.hide(true)
                        
                        hud.removeFromSuperview()
                    }
                    
                     
                }, failure:{ (errorMsg) in
                    self.view.isUserInteractionEnabled = true
                    hud.hide(true)
                    hud.removeFromSuperview()
                    
                    UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                })
            
        }
    }
    
    
    func get_DropdownValues() -> Void
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
            
            let dictUserInfo = ["secure_token":"CMPS-YticZiGte"] as [String : String]
            
            WebService.sharedInstance.postMethodWithParams(strURL: "get_city_zip.php", dict:dictUserInfo   as  NSDictionary, completionHandler:
                { (dictReponse) in
                    
                    print(dictReponse)
                    
                    OperationQueue.main.addOperation
                    {
                        let success = dictReponse.value(forKey: "success")
                        
                        var resultString : String!
                        
                        resultString = success as! String
                       
                        if resultString == "Successfully!"
                        {
                            self.dic_values = dictReponse.value(forKey: "city_state_zip") as! NSDictionary
                            
                            self.array_Zip = self.dic_values.value(forKey: "zip") as! NSArray
                        }
                        else
                        {
                            
                        }

                        hud.removeFromSuperview()
                            
                     }
                    
            }, failure:{ (errorMsg) in
             
                UIAlertController.Alert(title: "API Error", msg: "There seems to be a problem in fetching the data at the moment. Please try again.", vc: self)
                
                hud.removeFromSuperview()
                
            })
            
        }
    }

}
