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
        UdacityClient.sharedInstance().authenticate(usernameTextField.text, password: passwordTextField.text) { (success, errorString) in
            if success {
                println("Able to login")
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapNC") as UINavigationController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                println("Failed to login")
            }
        }
        
    }
    
    @IBAction func openCreateUdacityAccount(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityClient.Constants.SignInURL)!)
    }

}

