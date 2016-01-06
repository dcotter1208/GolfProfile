//
//  EditProfileViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/4/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ALCameraViewController


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var golferProfileImage: PFImageView!
    @IBOutlet weak var golferNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var editProfileData = [GolferProfile]()
    var loadProfileData = [GolferProfile]()
    var object: PFObject!
    var imagePicker = UIImagePickerController()
    let croppingEnabled = true
    let libraryEnabled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserProfile()
        imagePicker.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
                
        if golferProfileImage.image == nil {
        
        loadUserProfile()
        
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindSegueToProfile" {
            let profileVC = segue.destinationViewController as! ProfileViewController
            
            profileVC.golferProfileImage.file = self.golferProfileImage.file
        
        }
    }
    
    //THIS UPDATES AND SAVES THE CHANGES TO THE USER'S PROFILE
    @IBAction func saveProfileButton(sender: AnyObject) {
        activityIndicator.startAnimating()
        if let editUserQuery = PFUser.query() {
            editUserQuery.findObjectsInBackgroundWithBlock { (profilesToEdit: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object:PFObject in profilesToEdit! {
                        if let profile = object as? GolferProfile {
                            if profile.objectId == PFUser.currentUser()?.objectId {
                            self.editProfileData.append(profile)
                            profile.name = self.golferNameTextField.text!
                            profile.username = self.usernameTextField.text!
                            let pickedImage = self.golferProfileImage.image
                            let scaledImage = self.scaleImageWith(pickedImage!, newSize: CGSizeMake(400, 400))
                            let imageData = UIImagePNGRepresentation(scaledImage)
                            let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
                            profile.profileImage = golferImageFile!
                                
                            object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                             if success {
                                self.activityIndicator.stopAnimating()
                                self.performSegueWithIdentifier("unwindSegueToProfile", sender: self)
                                } else {
                                self.activityIndicator.stopAnimating()
                                self.displayAlert("Save Failed", message: "Please try again", actionTitle: "OK")
                                print("FAILED")
                                    }
                                })
                            }
                        }
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    print(error)
                }
            }
        }
    }

    
    @IBAction func editProfilePhoto(sender: UIButton) {
       
        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { (image) -> Void in
            self.golferProfileImage.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    
    }

    
    func scaleImageWith(image: UIImage, newSize: CGSize) -> UIImage {      
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    //Loads the current user's profile information into the edit view's textfields
    func loadUserProfile() {
        activityIndicator.startAnimating()
        if let userQuery = PFUser.query() {
        userQuery.findObjectsInBackgroundWithBlock({ (userProfiles:[PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
            self.activityIndicator.stopAnimating()
            self.displayAlert("Load Failed", message: "Please try again", actionTitle: "OK")
            self.loadUserProfile()
            } else {

        for object:PFObject in userProfiles! {
            self.activityIndicator.stopAnimating()
            if let profile = object as? GolferProfile {
                if profile.objectId == PFUser.currentUser()?.objectId {
                self.loadProfileData.append(profile)
                self.golferNameTextField.text = profile.name
                self.usernameTextField.text = profile.username
                self.golferProfileImage.file = profile.profileImage
                self.golferProfileImage.loadInBackground()
                        }
                    }
                }
            }
            })
        }
    }
    
    override func viewWillLayoutSubviews() {
        self.golferProfileImage.layer.borderWidth = 3.0
        self.golferProfileImage.layer.borderColor = UIColor.orangeColor().CGColor
        self.golferProfileImage.clipsToBounds = true
    }
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}



