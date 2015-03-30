//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 26/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import Foundation

struct StudentInformation {
    var objectId:String?
    var uniqueKey:String?
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        uniqueKey = dictionary["uniqueKey"] as? String
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        mapString = dictionary["mapString"] as? String
        mediaURL = dictionary["mediaURL"] as? String
        latitude = dictionary["latitude"] as? Double
        longitude = dictionary["longitude"] as? Double
    }
    
    func getFullName() -> String{
        var firstName = ""
        if self.firstName != nil {
            firstName = self.firstName!
        }
        
        var lastName = ""
        if self.lastName != nil {
            lastName = self.lastName!
        }
        
        return "\(firstName) \(lastName)"
    }
}