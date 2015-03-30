//
//  Helper.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 29/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    
    class func toogleViewFunctionality(view: UIView, activityIndicator: UIActivityIndicatorView, enable: Bool) {
        if enable {
            view.alpha = 0.6
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        } else {
            view.alpha = 1
            activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
    }
    
}