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
       getProfileFromBackground()
        
        print(PFUser.currentUser()!)
        
        if (PFUser.currentUser() == nil) {
            performSegueWithIdentifier("showLogin", sender: self)
            
        }

    }

    override func viewWillAppear(animated: Bool) {
        self.reloadInputViews()
        
        
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
    
    func getProfileFromBackground() {
        
        let query = PFQuery(className:"GolfProfile")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        query.findObjectsInBackgroundWithBlock { (profiles: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object:PFObject in profiles! {
                    self.profileData.append(object)
                    print(self.profileData)
                    
                            for data in self.profileData {
                                self.golferNameLabel.text = data.objectForKey("name") as? String
                                self.golferAge.text = data.objectForKey("age") as? String
                                self.golferCountry.text = data.objectForKey("country")as? String
                                self.golferDriver.text = data.objectForKey("driver")as? String
                                self.golferIron.text = data.objectForKey("irons") as? String
                                self.favoriteCourse.text = data.objectForKey("favoriteCourse") as? String
                                
                                let pfImage = data.objectForKey("profileImage") as? PFFile
                                pfImage?.getDataInBackgroundWithBlock({
                                    (result, error) in
                                    
                                    self.golferProfileImage.image = UIImage(data: result!)
                                })
                            }

                    
                    }
                } else {
                print(error)
            }
        }
        
    }
    
    
    
}




