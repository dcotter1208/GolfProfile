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

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var golferProfileImage: PFImageView!
    @IBOutlet weak var golferNameTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var editProfileData = [GolferProfile]()
    var loadProfileData = [GolferProfile]()
    var object: PFObject!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserProfile()
        imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //THIS UPDATES AND SAVES THE CHANGES TO THE USER'S PROFILE
    @IBAction func saveProfileButton(sender: AnyObject) {
        
        if let editUserQuery = PFUser.query() {
            editUserQuery.findObjectsInBackgroundWithBlock { (profilesToEdit: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
        
                    for object:PFObject in profilesToEdit! {
                        if let profile = object as? GolferProfile {
                            if profile.objectId == PFUser.currentUser()?.objectId {
                            self.editProfileData.append(profile)
                            profile.name = self.golferNameTextField.text!
                                
                            let pickedImage = self.golferProfileImage.image
                            let scaledImage = self.scaleImageWith(pickedImage!, newSize: CGSizeMake(100, 100))
                            let imageData = UIImagePNGRepresentation(scaledImage)
                            let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
                            profile.profileImage = golferImageFile!
                                
                            object.saveInBackground()
                                
                            }
                            
                        }
                        
                        
                    }
                    
                } else {
                    print(error)
                }
            }
        }
        
    }

    
    @IBAction func editProfilePhoto(sender: UIButton) {
        
        let actionSheet = UIAlertController(title: "Edit Profile Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (ACTION) -> Void in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (ACTION) -> Void in
            
        }
        
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
//  When we click on a photo - either from the photo library or taken from the camera - it will store it as our golferProfileImage
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        golferProfileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
        if let userQuery = PFUser.query() {
            userQuery.findObjectsInBackgroundWithBlock({ (userProfiles:[PFObject]?, error: NSError?) -> Void in
                
                for object:PFObject in userProfiles! {
                    if let profile = object as? GolferProfile {
                        if profile.objectId == PFUser.currentUser()?.objectId {
                            self.loadProfileData.append(profile)
                    
                        self.golferNameTextField.text = profile.name

                            self.golferProfileImage.file = profile.profileImage
                            self.golferProfileImage.loadInBackground()
           
                        }
                        
                    }
                    
                }
                
            })
            
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        self.golferProfileImage.layer.cornerRadius = 10
        self.golferProfileImage.layer.borderWidth = 3.0
        self.golferProfileImage.layer.borderColor = UIColor.blackColor().CGColor
        self.golferProfileImage.clipsToBounds = true
        
    }
    
}



