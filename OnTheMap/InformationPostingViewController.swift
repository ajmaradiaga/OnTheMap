//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 28/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationTextBox: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var linkTextBox: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var userLocation: CLLocation?
    var mapString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.performSegueWithIdentifier("LocationInformationContainer", sender:nil);
        findOnMapButton.layer.cornerRadius = 10.0
        submitButton.layer.cornerRadius = 10.0
        
        locationTextBox.tintColor = UIColor.whiteColor()
        locationTextBox.becomeFirstResponder()
        
        linkTextBox.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findOnTheMapTapped(sender: AnyObject) {
        
        var geoCoder = CLGeocoder()
    
        geoCoder.geocodeAddressString(locationTextBox.text, completionHandler: { (placemarks, error) -> Void in
            if error == nil {
                //Update UI
                self.submitButton.hidden = false
                self.mapView.hidden = false
                self.linkTextBox.hidden = false
                self.cancelButton.tintColor = UIColor.whiteColor()
                
                self.questionView.hidden = true
                self.locationTextBox.hidden = true
                self.findOnMapButton.hidden = true
                
                self.linkTextBox.becomeFirstResponder()
                
                self.mapString = self.locationTextBox.text
                
                //Process placemarks
                for placemark in placemarks
                {
                    self.userLocation = (placemark as CLPlacemark).location
                    
                    var enteredLocationAnnotation = MKPointAnnotation()
                    enteredLocationAnnotation.coordinate = self.userLocation!.coordinate
                    
                    self.mapView.addAnnotation(enteredLocationAnnotation)
                    
                    //Update Map
                    self.mapView.centerCoordinate = self.userLocation!.coordinate
                    
                    let miles = 5.0;
                    var scalingFactor = abs((cos(2 * M_PI * self.userLocation!.coordinate.latitude / 360.0) ))
                    
                    var span = MKCoordinateSpan(latitudeDelta: miles/69.0, longitudeDelta: miles/(scalingFactor*69.0))
                    
                    
                    var region = MKCoordinateRegion(center: self.userLocation!.coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    
                    println(self.userLocation!.coordinate.latitude)
                    println(self.userLocation!.coordinate.longitude)
                }
            } else {
                //Raise alert
            }
        })
    }
    
    @IBAction func submitInformation(sender: AnyObject) {
        var mediaURL = self.linkTextBox.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: mediaURL)!) {
            ParseClient.sharedInstance().postStudentLocation(self.mapString!, location: self.userLocation!, mediaURL: mediaURL, completionHandler: { (success, errorString) -> Void in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    //Raise alert
                }
            })
        } else {
            //RaiseAlert
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
