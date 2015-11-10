//
//  EditProfileViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/4/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var golferProfileImage: UIImageView!
    @IBOutlet weak var golferNameTextField: UITextField!
    @IBOutlet weak var golferAgeTextField: UITextField!
    @IBOutlet weak var golferCountryTextField: UITextField!
    @IBOutlet weak var driverTextField: UITextField!
    @IBOutlet weak var ironsTextField: UITextField!
    @IBOutlet weak var favoriteCourseTextField: UITextField!
    
    
    var editProfileData = [PFObject]()
    var loadProfileData = [PFObject]()
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
                        self.editProfileData.append(object)
                        print(self.editProfileData.count)
                        
                        if object.objectId == PFUser.currentUser()?.objectId {
                        object["name"] = self.golferNameTextField.text!
                        object["age"] = self.golferAgeTextField.text!
                        object["country"] = self.golferCountryTextField.text
                        object["driver"] = self.driverTextField.text!
                        object["irons"] = self.ironsTextField.text!
                        object["favoriteCourse"] = self.favoriteCourseTextField.text!
                        
                        let pickedImage = self.golferProfileImage.image
                        let scaledImage = self.scaleImageWith(pickedImage!, newSize: CGSizeMake(100, 100))
                        let imageData = UIImagePNGRepresentation(scaledImage)
                        let golferImageFile = PFFile(name: "profileImage.png", data: imageData!)
                        object["profileImage"] = golferImageFile
                        
                        object.saveInBackground()
                    }
                            
                    }
                    
                } else {
                    print(error)
                }
            }
        }
        
    }

    
    //********THIS FUNCTION LOADS THE CURRENT USER'S PROFILE INTO THE EDIT SCREEN'S TEXTFIELD*******

    
    func loadUserProfile() {
        if let userQuery = PFUser.query() {
        userQuery.findObjectsInBackgroundWithBlock({ (userProfiles:[PFObject]?, error: NSError?) -> Void in
                
                for object:PFObject in userProfiles! {
                    self.loadProfileData.append(object)
                    print(self.loadProfileData.count)
                    
                    for data in self.loadProfileData {
                        
                        if data.objectId == PFUser.currentUser()?.objectId {
                            self.golferNameTextField.text = data.objectForKey("name") as? String
                            self.golferAgeTextField.text = data.objectForKey("age") as? String
                            self.golferCountryTextField.text = data.objectForKey("country")as? String
                            self.driverTextField.text = data.objectForKey("driver")as? String
                            self.ironsTextField.text = data.objectForKey("irons") as? String
                            self.favoriteCourseTextField.text = data.objectForKey("favoriteCourse") as? String
                            print(data.objectForKey("username"))
                            
                            let pfImage = data.objectForKey("profileImage") as? PFFile
                            pfImage?.getDataInBackgroundWithBlock({
                                (result, error) in
                                
                                self.golferProfileImage.image = UIImage(data: result!)
                                
                            })
                            
                            
                        }
                        
                        
                    }
                }
            })
        }
    
    }
    

    @IBAction func camButton(sender: UIBarButtonItem) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func photoLibraryButton(sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
//    When we click on a photo - either from the photo library or taken from the camera - it will store it as our golferProfileImage
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

    }



