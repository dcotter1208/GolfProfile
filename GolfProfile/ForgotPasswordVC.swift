//
//  ForgotPasswordVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/18/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func resetPassword(sender: AnyObject) {
        
        let email = emailTextField.text?.lowercaseString
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        PFUser.requestPasswordResetForEmailInBackground(finalEmail)
        
        let alert = UIAlertController (title: "Password Reset", message: "An email containing information on how to reset your password has been sent to " + finalEmail + ".", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
