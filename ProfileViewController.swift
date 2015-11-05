//
//  ProfileViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    @IBOutlet weak var golferNameLabel: UILabel!
    @IBOutlet weak var golferAge: UILabel!
    @IBOutlet weak var golferCountry: UILabel!
    @IBOutlet weak var golferDriver: UILabel!
    @IBOutlet weak var golferIron: UILabel!
    @IBOutlet weak var favoriteCourse: UILabel!
    @IBOutlet weak var golferProfileImage: UIImageView!
    
    var profileData = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadProfile()
        
        print(PFUser.currentUser())
        
        
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("showLogin", sender: self)
            
        }

    }

    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("showLogin", sender: self)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func unwindSignupLogin(segue: UIStoryboardSegue) {
        
    }
    
    
    @IBAction func editProfile(sender: AnyObject) {
        
    }
    
    func loadProfile() {
        
        let query = PFQuery(className:"GolfProfile")
//        query.getObjectInBackgroundWithId((PFUser.currentUser()?.objectId)!)
            query.getObjectInBackgroundWithId("GwwIlTwydE") {
            (profile: PFObject?, error: NSError?) -> Void in
            if error == nil {
                
                self.golferNameLabel.text = profile!["name"] as? String
                self.golferAge.text = profile!["age"] as? String
                self.golferCountry.text = profile!["country"] as? String
                self.golferDriver.text = profile!["driver"] as? String
                self.golferIron.text = profile!["irons"] as? String
                self.favoriteCourse.text = profile!["favoriteCourse"] as? String
//                self.golferProfileImage.image = UIImage(named: "profileImage")! as UIImage
                
                let pfImage = profile!["profileImage"] as? PFFile
                
                pfImage!.getDataInBackgroundWithBlock({
                    (result, error) in
                    self.golferProfileImage.image = UIImage(data: result!)
                })
                
                print(profile)
            } else {
                print(error)
            }
        }
        
        }

    
    
    }



