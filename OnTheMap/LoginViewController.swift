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
        
        //Update appearance of text fields
        addPaddingViewToTextField(usernameTextField)
        addPaddingViewToTextField(passwordTextField)
    }
    
    func addPaddingViewToTextField(textField: UITextField) {
        let paddingView = UIView(frame:CGRectMake(0, 0, 15, 20))
        textField.leftView = paddingView
        textField.leftViewMode = .Always
    }

    @IBAction func loginToUdacity(sender: UIButton) {
        if self.usernameTextField.text.isEmpty {
            alertVC = Helper.raiseInformationalAlert(inViewController: self, withTitle:"Error", message: "Please enter your username.", completionHandler: { (alertAction) -> Void in
                self.usernameTextField.becomeFirstResponder()
                self.alertVC!.dismissViewControllerAnimated(true, completion: nil)
            })
            return
        }
        
        if self.passwordTextField.text.isEmpty {
            alertVC = Helper.raiseInformationalAlert(inViewController: self, withTitle:"Error", message: "Please enter your password.", completionHandler: { (alertAction) -> Void in
                self.passwordTextField.becomeFirstResponder()
                self.alertVC!.dismissViewControllerAnimated(true, completion: nil)
            })
            return
        }
        
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        
        Helper.updateCurrentView(self.view, withActivityIndicator: self.activityIndicator, andAnimate: true)
        UdacityClient.sharedInstance().authenticate(usernameTextField.text, password: passwordTextField.text) { (success, errorString) in
            dispatch_async(dispatch_get_main_queue(), {
                Helper.updateCurrentView(self.view, withActivityIndicator: self.activityIndicator, andAnimate: false)
            })
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNC") as! UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                Helper.raiseInformationalAlert(inViewController: self, withTitle:"Login error", message: errorString!, completionHandler: { (alertAction) -> Void in
                    self.alertVC!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
        
    }

    @IBAction func openCreateUdacityAccount(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityClient.Constants.SignInURL)!)
    }

}

