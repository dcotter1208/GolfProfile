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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func login(sender: AnyObject) {
        
        logIn()
    }
    
    
    func logIn() {
        //Taking the user that is typed into the text fields and seeing if it is valid with the Parse network.
        var user = PFUser()
        user.username = usernameTextField.text?.lowercaseString
        user.password = passwordTextField.text?.lowercaseString
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!)
    }

}
