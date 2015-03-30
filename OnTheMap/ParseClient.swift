//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 25/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import Foundation
import MapKit

class ParseClient: NSObject{
    /* Shared session */
    var session: NSURLSession
    var refreshingStudentLocations: Bool = false
    
    var allStudentLocations: [StudentInformation] = []
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func refreshStudentLocations(completionHandler: (success: Bool, errorString: String?) -> Void) {
        if !refreshingStudentLocations {
            refreshingStudentLocations = true
            var tempStudentLocations: [StudentInformation] = []
            let request = NSMutableURLRequest(URL: NSURL(string: Methods.StudentLocation)!)
            request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    completionHandler(success: false, errorString: error.description)
                } else {
                    //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    NetworkHelper.parseJSONWithCompletionHandler(data) { (result, error) -> Void in
                        if let results = result["results"] as? [AnyObject] {
                            for result in results {
                                var sl = StudentInformation(dictionary: result as NSDictionary)
                                tempStudentLocations.append(sl)
                            }
                            self.allStudentLocations = tempStudentLocations
                            completionHandler(success: true, errorString: nil)
                        }else {
                            completionHandler(success: false, errorString: "No results structure found in response.")
                        }
                    }
                }
                self.refreshingStudentLocations = false
            }
            task.resume()
        }
    }
    
    func postStudentLocation(mapString: String, location: CLLocation, mediaURL: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if !refreshingStudentLocations {
            refreshingStudentLocations = true
            var tempStudentLocations: [StudentInformation] = []
            let request = NSMutableURLRequest(URL: NSURL(string: Methods.StudentLocation)!)
            request.HTTPMethod = "POST"
            request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.HTTPBody = "{\"uniqueKey\": \"324586\", \"firstName\": \"\(UdacityClient.sharedInstance().user.firstName!)\", \"lastName\": \"\(UdacityClient.sharedInstance().user.lastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\":\(location.coordinate.latitude), \"longitude\": \(location.coordinate.longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { // Handle error...
                    completionHandler(success: false, errorString: error.description)
                } else {
                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    NetworkHelper.parseJSONWithCompletionHandler(data) { (result, error) -> Void in
                       println(result)
                    }
                    completionHandler(success: true, errorString: nil)
                }
                self.refreshingStudentLocations = false
            }
            task.resume()
        }
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}
