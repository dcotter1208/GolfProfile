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
        let user = PFUser()
        user.username = signUpUsernameTextField.text?.lowercaseString
        user.password = signUpPasswordTextField.text?.lowercaseString
        user.email = signUpEmailTextField.text?.lowercaseString
        user["name"] = ""
        user["age"] = ""
        user["country"] = ""
        user["driver"] = ""
        user["irons"] = ""
        user["favoriteCourse"] = ""
        let imageData = UIImagePNGRepresentation(UIImage(named: "defaultUser")!)
        let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
        user["profileImage"] = golferImageFile
        
        // If creating the user was successful then we log them in and display the ProfielViewController....***I HOOKED THIS UP TO A UNWIND SEGUE***
        
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
         if error == nil {
  
            if PFUser.currentUser() != nil {
             dispatch_async(dispatch_get_main_queue()) {
             self.dismissViewControllerAnimated(true, completion: nil)
                }
                                
            }
                                    
         } else {
            print(error)
        }
    }
}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
}




