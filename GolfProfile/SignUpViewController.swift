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
        
        // If creating the user was successful then we log them in and display the ProfielViewController....***I HOOKED THIS UP TO A UNWIND SEGUE***
        
        user.signUpInBackgroundWithBlock {(succeeded: Bool, error: NSError?) -> Void in
                        if error == nil {
        //********IF THE NEW USER CREATION IS SUCCESSFUL IT THEN MAKES DEFAULT USER NAME FOR THAT USER*********
                            let golferProfile = PFObject(className:"GolfProfile")
                            
                            golferProfile["user"] = PFUser.currentUser()
                            golferProfile["name"] = ""
                            golferProfile["age"] = ""
                            golferProfile["country"] = ""
                            golferProfile["driver"] = ""
                            golferProfile["irons"] = ""
                            golferProfile["favoriteCourse"] = ""
                            
                            let imageData = UIImagePNGRepresentation(UIImage(named: "defaultUser")!)
                            let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
                            golferProfile["profileImage"] = golferImageFile

                            golferProfile.saveInBackgroundWithBlock {
                                (success: Bool, error: NSError?) -> Void in
                                if (success) {
                                    
//                                    performSegueWithIdentifier("signUpToProfile", sender: self)
                                    
                                } else {
                                    print(error)
                                    
                                }
                            }
                            
                        }
            
                    }
            
                }
        
            }



