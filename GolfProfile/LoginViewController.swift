//
//  LoginViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("showUserProfile", sender: self)
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: AnyObject) {
        let user = PFUser()
        user.username = self.usernameTextField.text?.lowercaseString
        user.password = self.passwordTextField.text?.lowercaseString
        
        PFUser.logInWithUsernameInBackground(self.usernameTextField.text!, password: self.passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("showUserProfile", sender: self)
                    
                }
                
            }
            
        }
    
        
    }
    
    
    @IBAction func unwindSignupLogin(segue: UIStoryboardSegue) {
        
        usernameTextField.text = ""
        passwordTextField.text = ""
        
    }
    

}

