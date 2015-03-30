//
//  ViewController.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 25/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var alertVC: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let paddingView = UIView(frame:CGRectMake(0, 0, 15, 20))
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .Always
        
        let paddingView2 = UIView(frame:CGRectMake(0, 0, 15, 20))
        passwordTextField.leftView = paddingView2
        passwordTextField.leftViewMode = .Always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginToUdacity(sender: UIButton) {
        if self.usernameTextField.text.isEmpty {
            raiseInformationalAlert("Error", message: "Please enter your username.", completionHandler: { (alertAction) -> Void in
                self.usernameTextField.becomeFirstResponder()
                self.alertVC!.dismissViewControllerAnimated(true, completion: nil)
            })
            return
        }
        
        if self.passwordTextField.text.isEmpty {
            raiseInformationalAlert("Error", message: "Please enter your password.", completionHandler: { (alertAction) -> Void in
                self.passwordTextField.becomeFirstResponder()
                self.alertVC!.dismissViewControllerAnimated(true, completion: nil)
            })
            return
        }
        
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        Helper.toogleViewFunctionality(self.view, activityIndicator: self.activityIndicator, enable: true)
        UdacityClient.sharedInstance().authenticate(usernameTextField.text, password: passwordTextField.text) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                Helper.toogleViewFunctionality(self.view, activityIndicator: self.activityIndicator, enable: false)
            })
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNC") as UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                self.raiseInformationalAlert("Login error", message: errorString!, completionHandler: { (alertAction) -> Void in
                    self.alertVC!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        
    }
    
    func raiseInformationalAlert(title: String, message: String, completionHandler: ((UIAlertAction!) -> Void)) {
        alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //Add Actions to UIAlertController
        alertVC!.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: completionHandler))
        
        self.presentViewController(alertVC!, animated: true, completion: nil)
    }
    
    @IBAction func openCreateUdacityAccount(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityClient.Constants.SignInURL)!)
    }

}

