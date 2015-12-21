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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func signUpButton(sender: AnyObject) {
        signUp()
        
    }
    
    func signUp() {
        let user = PFUser()
        user.username = signUpUsernameTextField.text?.lowercaseString
        user.password = signUpPasswordTextField.text?.lowercaseString
        user.email = signUpEmailTextField.text?.lowercaseString
        
        
        user["name"] = firstNameTextField.text! + " " + lastNameTextField.text!
        let imageData = UIImagePNGRepresentation(UIImage(named: "defaultUser")!)
        let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
        user["profileImage"] = golferImageFile
        
        if signUpUsernameTextField.text!.characters.count < 5 {
            
            let alertController = UIAlertController(title: "Invalid", message: "Username must be greater than 5 characters", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)

            
        } else if signUpPasswordTextField.text!.characters.count < 8 {
            let alertController = UIAlertController(title: "Invalid", message: "Password must be greater than 8 characters", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else if signUpEmailTextField.text!.characters.count < 8 {
            let alertController = UIAlertController(title: "Invalid", message: "Please enter a valid e-mail address", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
        
        // If creating the user was successful then we log them in and display the ProfielViewController
            
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
         if succeeded {

//            let alertController = UIAlertController(title: "Welcome \(user.username!)!", message: nil, preferredStyle: .Alert)
//            
//            let OKAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
//        
//            alertController.addAction(OKAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
            
            if PFUser.currentUser() != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Home")
                    self.presentViewController(viewController, animated: true, completion: nil)
                    
                }
            }
            
        
         } else {
            
            if error?.code == 202 {
                let alertController = UIAlertController(title: "Username Taken!", message: "Please choose a different username.", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}




