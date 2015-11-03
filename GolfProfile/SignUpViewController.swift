//
//  SignUpViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        signUp()
        
    }
    
    func signUp() {
        var user = PFUser()
        user.username = signUpUsernameTextField.text?.lowercaseString
        user.password = signUpPasswordTextField.text?.lowercaseString
        user.email = signUpEmailTextField.text?.lowercaseString
        
        // If creating the user was successful then we log them in and display the ProfielViewController....***I HOOKED THIS UP TO A UNWIND SEGUE***
        
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
            //            if error == nil { dispatch_async(dispatch_get_main_queue()) {
            //                self.performSegueWithIdentifier("ToTableView", sender: self) }
            //            }
            
        }
        
    }


}
