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
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        let user = PFUser()
        user.username = signUpEmailTextField.text?.lowercaseString
        user.password = signUpPasswordTextField.text
        user.email = signUpEmailTextField.text?.lowercaseString
        
        user["name"] = firstNameTextField.text! + " " + lastNameTextField.text!
        let imageData = UIImagePNGRepresentation(UIImage(named: "defaultUser")!)
        let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
        user["profileImage"] = golferImageFile
        
        if signUpPasswordTextField.text!.characters.count < 8 {
            
            activityIndicator.stopAnimating()
            
            displayAlert("Invalid Password", message: "Password must be greater than 8 characters", actionTitle: "OK")
            
        } else if isValidEmail(signUpEmailTextField.text!) == false {
            activityIndicator.stopAnimating()
            
            displayAlert("Invalid", message: "Please enter a valid e-mail address", actionTitle: "OK")

        } else if firstNameTextField.text?.characters.count > 12 {
            activityIndicator.stopAnimating()
            
            displayAlert("First name too long", message: "Please choose a first name less than 12 characters", actionTitle: "OK")
        
        } else if lastNameTextField.text?.characters.count > 12{
        
            activityIndicator.stopAnimating()
            
            displayAlert("Last name too long", message: "Please choose a last name less than 12 characters", actionTitle: "OK")
            
        } else {
        
            
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
         if succeeded {
        self.activityIndicator.stopAnimating()
        PFUser.logOutInBackground()
            
          let alertController = UIAlertController(title: "Success!", message: "Now Please Login", preferredStyle: .Alert)
                
            let enterAppAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)

            })
                
                alertController.addAction(enterAppAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
        
         } else {
            
            if error?.code == 202 {
                self.activityIndicator.stopAnimating()
                self.displayAlert("Invalid E-mail", message: "\(self.signUpEmailTextField.text!) is already in use", actionTitle: "OK")

                }
            
            
            if error?.code == 203 {
                self.activityIndicator.stopAnimating()
                self.displayAlert("Invalid E-mail", message: "\(self.signUpEmailTextField.text!) is already in use", actionTitle: "OK")
                
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
    
    
    func containsWhiteSpace(string: String) -> Bool {
        
        // check if there's a range for a whitespace
        let range = string.rangeOfCharacterFromSet(.whitespaceCharacterSet())
        
        // returns false when there's no range for whitespace
        if let _ = range {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(testStr)
        
        return result
        
    }
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
    
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        }
    
}




