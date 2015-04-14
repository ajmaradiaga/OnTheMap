//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 26/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import Foundation

class UdacityClient: NSObject{
    
    /* Shared session */
    var session: NSURLSession
    var user: UdacityUser!
    
    override init() {
        session = NSURLSession.sharedSession()
        user = UdacityUser()
        super.init()
    }
    
    func authenticate(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityClient.Methods.Session)!)
        request.HTTPMethod = "POST"
        request.addValue(Constants.JSONType, forHTTPHeaderField: "Accept")
        request.addValue(Constants.JSONType, forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                // Handle network error
                completionHandler(success: false, errorString: "Error communicating with Udacity API Session.")
            } else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
                NetworkHelper.parseJSONWithCompletionHandler(newData, completionHandler: { (result, error) -> Void in
                    
                    //println(result as NSDictionary)
                    if error == nil {
                        //Handle error returned by the API
                        if let errorString = result["error"] as? String {
                            completionHandler(success: false, errorString: errorString)
                        } else {
                            //Grab account details to extract the userId
                            let accountDetails = result["account"] as! NSDictionary
                            self.user.userId = accountDetails["key"] as? NSString
                            self.getPublicUserData(completionHandler)
                        }
                    } else {
                        completionHandler(success: false, errorString: error!.description)
                    }
                })
            }
        }
        task.resume()
    
    }
    
    func getPublicUserData(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(UdacityClient.Methods.PublicUser)/\(user.userId!)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(success: false, errorString: "Error communicating with Udacity API Users.")
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            
            NetworkHelper.parseJSONWithCompletionHandler(newData, completionHandler: { (result, error) -> Void in
                //Grab account details to extract the userId
                let userDetails = result["user"] as! NSDictionary
                self.user.firstName = userDetails["first_name"] as? NSString
                self.user.lastName = userDetails["last_name"] as? NSString
                
                completionHandler(success: true, errorString: nil)
            })
        }
        task.resume()
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}