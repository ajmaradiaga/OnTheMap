//
//  MapTabViewController.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 26/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit
import MapKit


class MapTabViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedAnnotation: MKAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "map")
        
        // Do any additional setup after loading the view.
        ParseClient.sharedInstance().refreshStudentLocations { (success, errorString) -> Void in
            if(success) {
                self.refreshData(nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(sender:AnyObject?) {
        for studentLocation in ParseClient.sharedInstance().allStudentLocations {
            var studentLocationAnnotation = MKPointAnnotation()
            studentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude!, longitude: studentLocation.longitude!)
            studentLocationAnnotation.title = "\(studentLocation.getFullName())"
            studentLocationAnnotation.subtitle = "\(studentLocation.mediaURL!)"
            self.mapView.addAnnotation(studentLocationAnnotation)
        }
        //Refresh current map region
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.setCenterCoordinate(self.mapView.region.center, animated: true)
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "studentLocationPin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.animatesDrop = true
            pinView!.pinColor = .Purple

            //Prepare disclosure button that will be added to the pin
            var disclosureButton = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIButton
            disclosureButton.addTarget(self, action: Selector("goToLink:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            pinView!.rightCalloutAccessoryView = disclosureButton
            pinView!.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func goToLink(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: selectedAnnotation!.subtitle!)!)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        //Save the selected annotation
        selectedAnnotation = view.annotation
    }
}
