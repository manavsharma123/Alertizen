//
//  WebService.swift
//  Raj
//
//  Created by Raj on 01/06/16.
//  Copyright © 2016 Raj. All rights reserved.
//

import UIKit

class WebService: NSObject {
    //private let baseURL = "http://5dubs.com/api/"
    private let baseURL = "https://www.alertizen.com/campus_api/"
    
    static let sharedInstance : WebService = {
        let instance = WebService()
        return instance
    }()
    
    //////////////////////////////////////////////////
    //************** GET API Section **************//
    //////////////////////////////////////////////////
    
    //MARK:- Post API Methods
//    func getMethedWithoutParams(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
//        
//        let url = "https://itunes.apple.com/search?term=Beatles&media=music&entity=album"
//        
//        let request : NSURLRequest = self.createGetRequest(url: url)
//        
//        self.callAPI(request: request, completionHandler: { (responseDict) in
//            
//            completionHandler(responseDict)
//            
//            }, failure: { (error) in
//                
//                failure(error)
//        })
//    }
    
    
    func getMethodWithParams(_ strServiceType: String, dict: NSDictionary, completionHandler:@escaping (_ dict: NSDictionary) -> Void, failure:@escaping (_ error: String) -> Void) -> Void {
        
        var strUrl = String()
        
        strUrl = strUrl.createUrlForGetMethodWithParams(dict: dict)
        
        strUrl = "\(baseURL)\(strServiceType)\(strUrl)"
//        print(strUrl)
//        self.callGetAPI("\(baseURL)\(strUrl)")
        
        let request : NSURLRequest = self.createGetRequest(url: strUrl)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
            
                completionHandler(responseDict)
            
            }, failure: { (error) in
                
                failure(error)
        })
    }
    
    
    private func createGetRequest(url: String) -> NSURLRequest
    {
        let urlPath = NSURL(string: url)
        
        let request = NSMutableURLRequest(url: urlPath! as URL)
        
        request.timeoutInterval = 60
        
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
        return request
    }
    
    //////////////////////////////////////////////////
    //************** POST API Section **************//
    //////////////////////////////////////////////////
    
    //MARK:- Post API Methods
    func postMethodWithoutParams(completionHandler:(_ dict :NSDictionary) -> Void) -> Void {
        
    }
    
    func postMethodWithParams(strURL: String, dict:NSDictionary, completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ errorMsg : String) -> Void) -> Void {
        
        let request = self.PostWithParamAndImage(strURL: strURL, dictParam: dict, file: nil, fileKey: nil, fileName: nil)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
                print(responseDict)
            completionHandler(responseDict)
            }, failure: { (error) in
                 print(error)
                failure(error)
        })
        
        /*var strUrl = String()
        
        strUrl = strUrl.createUrlForGetMethodWithParams(dict)
        if strUrl.hasPrefix("?")
        {
            strUrl = String(strUrl.characters.dropFirst())
        }
        self.doRequestPostWithParam("http://cloudart.com.au/projects/stack_ios/index.php", dataParam: strUrl)
        
        doRequestPost("http://cloudart.com.au/projects/stack_ios/index.php", data: dict as! [String : NSObject])*/
    }
    
    
    func postMethodWithParamsAndImage(strURL: String, dictParams: NSDictionary, image: UIImage?, imagesKey: String, imageName:String,completionHandler:@escaping (_ dict :NSDictionary) -> Void, failue:@escaping (_ error: String) -> Void)
    {
        let request = self.PostWithParamAndImage(strURL: strURL, dictParam: dictParams, file: image, fileKey: imagesKey, fileName: imageName)
        
        self.callAPI(request: request, completionHandler: { (responseDict) in
//                print(responseDict)
            completionHandler(responseDict)
            }, failure: { (error) in
//                print(error)
                failue(error)
        })
    }
    
    
    private func PostWithParamAndImage(strURL: String,dictParam: NSDictionary, file: UIImage?, fileKey: String?, fileName: String?) -> NSURLRequest
    {
        let myUrl = NSURL(string: "\(baseURL)\(strURL)")
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
    
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if file != nil
        {
            let imageData = UIImageJPEGRepresentation(file!, 1)
            
            request.httpBody = createBodyWithParametersAndImage(parameters: dictParam, filePathKey: fileKey!, fileName: fileName!, imageDataKey: imageData! as NSData, boundary: boundary) as Data
        }
        else
        {
            request.httpBody = createBodyWithParameters(parameters: dictParam, boundary: boundary) as Data
        }
        return request;
    }
    
    
    private func createBodyWithParametersAndImage(parameters: NSDictionary, filePathKey: String?, fileName: String?, imageDataKey: NSData, boundary: String) -> NSData
    {
        let body = NSMutableData();
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        let filename = "\(fileName!).jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    private func createBodyWithParameters(parameters: NSDictionary, boundary: String) -> NSData {
        
        let body = NSMutableData();
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    //MARK:- Common For Both (GET & POST)
    private func callAPI(request: NSURLRequest, completionHandler:@escaping (_ responseDict: NSDictionary) -> Void, failure:@escaping (_ error: String) -> Void) -> Void {
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                //  print("error=\(error)")
                failure(error!.localizedDescription)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode == 200 {           // check for http errors
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
                //
                //                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //                print("responseString = \(responseString)")
                
                do {                    
                    let responseDict = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    // use anyObj here
                    completionHandler(responseDict)
                } catch let error as NSError {
//                    print("json error: \(error.localizedDescription)")
                    failure("json error: \(error.localizedDescription)")
                }
            }
            else
            {
                let httpStatus = response as? HTTPURLResponse
                failure("API Response status code : \(httpStatus?.statusCode)")
            }
        }
        task.resume()
    }
    
    /*
    private func callGetAPI(url:String){
        
        let session = NSURLSession.sharedSession()
        
        let urlPath = NSURL(string: url)
        let request = NSMutableURLRequest(URL: urlPath!)
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "GET"
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            if((error) != nil) {
                print(error!.localizedDescription)
                
            }else {
                _ = NSString(data: data!, encoding:NSUTF8StringEncoding)
                let _: NSError?
                let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:    NSJSONReadingOptions.MutableContainers)
                
                print(jsonResult)
                
            }
        }
        dataTask.resume()
    }
    
    
    func doRequestPostWithParam(url:String,dataParam:String) -> Void {
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        let postString = dataParam
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    func doRequestPostParamWithJson(url:String,data:[String: NSObject]){
        
        let theJSONData = try? NSJSONSerialization.dataWithJSONObject(
            data ,
            options: NSJSONWritingOptions(rawValue: 0))
     
        let jsonString = NSString(data: theJSONData!,
                                  encoding: NSASCIIStringEncoding)
        
        print("Request Object:\(data)")
        print("Request string = \(jsonString!)")
        
        let session = NSURLSession.sharedSession()
        
        let urlPath = NSURL(string: url)
        let request = NSMutableURLRequest(URL: urlPath!)
        request.timeoutInterval = 60
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        let postLength = NSString(format:"%lu", jsonString!.length) as String
        
        request.setValue(postLength, forHTTPHeaderField:"Content-Length")
        
        request.HTTPBody = jsonString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
        
        let dataTask = session.dataTaskWithRequest(request) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if((error) != nil) {
                print(error!.localizedDescription)
                
            }else {
                print("Succes:")
                _ = NSString(data: data!, encoding:NSUTF8StringEncoding)
                let _: NSError?
                let jsonResult: AnyObject = try! NSJSONSerialization.JSONObjectWithData(data!, options:    NSJSONReadingOptions.MutableContainers)
                print(jsonResult)
            }
        }
        dataTask.resume()
    }
 
 
 */
    
//    func doRequestPostWithParamAndImage()
//    {
//        
//        let myUrl = NSURL(string: "http://www.swiftdeveloperblog.com/http-post-example-script/");
//        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
//        
//        let request = NSMutableURLRequest(URL:myUrl!);
//        request.HTTPMethod = "POST";
//        
//        let param = [
//            "firstName"  : "Sergey",
//            "lastName"    : "Kargopolov",
//            "userId"    : "9"
//        ]
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        
//        let imageData = UIImageJPEGRepresentation(myImageView.image, 1)
//        
//        if(imageData == nil)  { return; }
//        
//        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
//        
//        
//        
////        myActivityIndicator.startAnimating();
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                print("error=\(error)")
//                return
//            }
//            
//            // You can print out response object
//            print("******* response = \(response)")
//            
//            // Print out reponse body
//            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
//            print("****** response data = \(responseString!)")
//            
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err) as? NSDictionary
//            
//            
//            
//            dispatch_async(dispatch_get_main_queue(),{
////                self.myActivityIndicator.stopAnimating()
////                self.myImageView.image = nil;
//            });
//            
//            /*
//             if let parseJSON = json {
//             var firstNameValue = parseJSON["firstName"] as? String
//             println("firstNameValue: \(firstNameValue)")
//             }
//             */
//            
//        }
//        
//        task.resume()
//
//    }
//    
//    
//    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//        
//        let body = NSMutableData();
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
//        let filename = "user-profile.jpg"
//        
//        let mimetype = "image/jpg"
//        
//        body.appendString("--\(boundary)\r\n")
//        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
//        body.appendData(imageDataKey)
//        body.appendString("\r\n")
//        
//        body.appendString("--\(boundary)--\r\n")
//        
//        return body
//    }
//    
//    private func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().UUIDString)"
//    }
    
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


extension String
{
    func createUrlForGetMethodWithParams(dict : NSDictionary) -> String {
        var stringUrl1 : String!
        var firstTime1 = "yes"
        
        for (key,value) in dict {
            
            let stringVal = value as! String
            
            if let percentEscapedString = stringVal.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            {
                if firstTime1 == "yes" {
                    stringUrl1 = "?\(key)=\(percentEscapedString)"
                    firstTime1 = "no"
                }
                else {
                    stringUrl1 = "\(stringUrl1!)&\(key)=\(percentEscapedString)"
                }
            }
        }
//        print(stringUrl1)
        
        return stringUrl1
        
    }
}

