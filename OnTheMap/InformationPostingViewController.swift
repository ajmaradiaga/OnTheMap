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
    @IBOutlet weak var browseToURLButton: UIButton!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userLocation: CLLocation?
    var mapString: String?
    var alertVC: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.performSegueWithIdentifier("LocationInformationContainer", sender:nil);
        findOnMapButton.layer.cornerRadius = 10.0
        submitButton.layer.cornerRadius = 10.0
        
        updateTextBoxAppearance(locationTextBox, placeholderText: locationTextBox.placeholder!)
        updateTextBoxAppearance(linkTextBox, placeholderText: linkTextBox.placeholder!)
        
        locationTextBox.becomeFirstResponder()
    }

    func updateTextBoxAppearance(textBox: UITextField, placeholderText: String) {
        var placeholderConfig = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        textBox.attributedPlaceholder = placeholderConfig
        textBox.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func findOnTheMapTapped(sender: AnyObject) {
        
        var geoCoder = CLGeocoder()
        
        Helper.toogleViewFunctionality(self.view, activityIndicator: self.activityIndicator, enable: true)
        
        geoCoder.geocodeAddressString(locationTextBox.text, completionHandler: { (placemarks, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                Helper.toogleViewFunctionality(self.view, activityIndicator: self.activityIndicator, enable: false)
            })
            if error == nil {
                //Update UI
                self.submitButton.hidden = false
                self.mapView.hidden = false
                self.linkTextBox.hidden = false
                self.browseToURLButton.hidden = false
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
                    
                    //Update Map Region
                    self.mapView.centerCoordinate = self.userLocation!.coordinate
                    
                    let miles = 5.0;
                    var scalingFactor = abs((cos(2 * M_PI * self.userLocation!.coordinate.latitude / 360.0) ))
                    
                    var span = MKCoordinateSpan(latitudeDelta: miles/69.0, longitudeDelta: miles/(scalingFactor*69.0))
                    
                    
                    var region = MKCoordinateRegion(center: self.userLocation!.coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                }
            } else {
                self.raiseInformationalAlert("Error", message: "Location is invalid. Please enter a valid Location.")
            }
        })
    }
    
    @IBAction func submitInformation(sender: AnyObject) {
        var mediaURL = self.linkTextBox.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: mediaURL)!) {
            Helper.toogleViewFunctionality(self.view, activityIndicator: activityIndicator, enable: true)
            ParseClient.sharedInstance().postStudentLocation(self.mapString!, location: self.userLocation!, mediaURL: mediaURL, completionHandler: { (success, errorString) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    Helper.toogleViewFunctionality(self.view, activityIndicator: self.activityIndicator, enable: false)
                })
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.raiseRetryAlert("Error", message: errorString!)
                }
            })
        } else {
            self.raiseInformationalAlert("Error", message: "Link is invalid. Please enter a valid URL.")
        }
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func browseToURLAction(sender: AnyObject) {
        var mediaURL = self.linkTextBox.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: mediaURL)!) {
           UIApplication.sharedApplication().openURL(NSURL(string: mediaURL)!)
        } else {
            self.raiseInformationalAlert("Error", message: "Link is invalid. Please enter a valid URL.")
        }
    }
    
    
    func raiseInformationalAlert(title: String, message: String) {
        alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add Actions to UIAlertController
        alertVC!.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: alertActionHandler))
        
        self.presentViewController(alertVC!, animated: true, completion: nil)
    }
    
    func raiseRetryAlert(title: String, message: String) {
        
        alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add Actions to UIAlertController
        alertVC!.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: alertActionHandler))
        alertVC!.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: alertActionHandler))
        
        self.presentViewController(alertVC!, animated: true, completion: nil)
        
    }
    
    //Handles the option selected by the user in the memeAction - UIAlertController
    func alertActionHandler(sender: UIAlertAction!) -> Void{
        if(sender.title == "Retry"){
            submitInformation(self)
        } else if(sender.title == "Cancel" || sender.title == "Ok") {
            alertVC!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
