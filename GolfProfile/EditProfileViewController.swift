//
//  EditProfileViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/4/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var golferNameTextField: UITextField!
    @IBOutlet weak var golferAgeTextField: UITextField!
    @IBOutlet weak var golferCountryTextField: UITextField!
    @IBOutlet weak var driverTextField: UITextField!
    @IBOutlet weak var ironsTextField: UITextField!
    @IBOutlet weak var favoriteCourseTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveProfileButton(sender: AnyObject) {
        
        let imageData = UIImagePNGRepresentation(self.profileImage.image!)
        let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
        
        let golferProfile = PFObject(className:"GolfProfile")
        golferProfile["name"] = golferNameTextField.text!
        golferProfile["age"] = golferAgeTextField.text!
        golferProfile["country"] = golferCountryTextField.text!
        golferProfile["driver"] = driverTextField.text!
        golferProfile["irons"] = ironsTextField.text!
        golferProfile["favoriteCourse"] = favoriteCourseTextField.text!
        golferProfile["profileImage"] = golferImageFile
        golferProfile.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                
            } else {
                // There was a problem, check error.description
            }
        }
        
    }


}
