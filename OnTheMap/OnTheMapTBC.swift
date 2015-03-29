//
//  OnTheMapTBC.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 27/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class OnTheMapTBC: UITabBarController {
    
    var pinBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pinBarButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("postLocation:"))
        
        self.navigationItem.leftBarButtonItem = pinBarButton
        
    }
    
    @IBAction func refreshData(sender: AnyObject) {
        if !ParseClient.sharedInstance().refreshingStudentLocations {
            ParseClient.sharedInstance().refreshStudentLocations({ (success, errorString) -> Void in
                if success {
                    if self.selectedViewController!.isKindOfClass(MapTabViewController.classForCoder()) {
                        (self.selectedViewController as MapTabViewController).refreshData(nil)
                    } else if self.selectedViewController!.isKindOfClass(LocationsTableViewController.classForCoder()) {
                        (self.selectedViewController as LocationsTableViewController).refreshData(nil)
                    
                    }
                }
            })
        }
    }
    
    func postLocation(sender: AnyObject) {
        println("postLocation")
        /*
        ParseClient.sharedInstance().postStudentLocation { (success, errorString) -> Void in
            println("")
        }*/
        
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("InformationPostingVC") as UIViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}
