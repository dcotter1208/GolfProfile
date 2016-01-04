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
            
            displayAlert("Invalid", message: "Username must be greater than 5 characters", actionTitle: "OK")

        } else if containsWhiteSpace(signUpUsernameTextField.text!) {
            
            displayAlert("Username Invalid", message: "Username can not contain spaces", actionTitle: "OK")
        
        } else if containsWhiteSpace(signUpPasswordTextField.text!) {
            
            displayAlert("Password Invalid", message: "Password can not contain spaces.", actionTitle: "OK")
            
        } else if signUpPasswordTextField.text!.characters.count < 8 {
            
            displayAlert("Invalid Password", message: "Password must be greater than 8 characters", actionTitle: "OK")
            
        } else if isValidEmail(signUpEmailTextField.text!) == false {
            
            displayAlert("Invalid", message: "Please enter a valid e-mail address", actionTitle: "OK")

        } else if firstNameTextField.text?.characters.count > 12 {
            
            displayAlert("First name too long", message: "Please choose a first name less than 12 characters", actionTitle: "OK")
        
        } else if lastNameTextField.text?.characters.count > 12{
        
            displayAlert("Last name too long", message: "Please choose a last name less than 12 characters", actionTitle: "OK")
            
        } else {
        
        // If creating the user was successful then we log them in and display the ProfileViewController
            
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
         if succeeded {
        PFUser.logOutInBackground()
          let alertController = UIAlertController(title: "Success!", message: "Now Please Log", preferredStyle: .Alert)
                
            let enterAppAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)

            })
                
                alertController.addAction(enterAppAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
        
         } else {
            
            if error?.code == 202 {
                
                self.displayAlert("Username Taken!", message: "Please choose a different username.", actionTitle: "OK")

                }
            
            
            if error?.code == 203 {
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




