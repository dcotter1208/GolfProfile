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
        
        self.golferProfileImage.layer.cornerRadius = self.golferProfileImage.frame.size.width / 2
        self.golferProfileImage.layer.borderWidth = 3.0
        self.golferProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.golferProfileImage.clipsToBounds = true
        
    

        if PFUser.currentUser() == nil {
            
            self.performSegueWithIdentifier("showLogin", sender: self)
            
        }
        
    

        
    }

        override func viewDidAppear(animated: Bool) {
            if (PFUser.currentUser() == nil) {
                performSegueWithIdentifier("showLogin", sender: self)
            }
            
    }

    override func viewWillAppear(animated: Bool) {
        getProfileFromBackground()

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("showLogin", sender: self)
        print (PFUser.currentUser())
        
    }
    
    
    @IBAction func editProfile(sender: AnyObject) {
        
    }
    
    func getProfileFromBackground() {
    profileData.removeAll()
    if let userQuery = PFUser.query() {
     userQuery.findObjectsInBackgroundWithBlock({ (userProfiles:[PFObject]?, error: NSError?) -> Void in
        if error == nil {
        dispatch_async(dispatch_get_main_queue()) {
                    for object:PFObject in userProfiles! {
                    self.profileData.append(object)
                    print(self.profileData.count)
                
                    for data in self.profileData {
                        
                        self.profileData.removeAll()
                        
                        if data.objectId == PFUser.currentUser()?.objectId {
                            self.golferNameLabel.text = data.objectForKey("name") as? String
                            self.golferAge.text = data.objectForKey("age") as? String
                            self.golferCountry.text = data.objectForKey("country")as? String
                            self.golferDriver.text = data.objectForKey("driver")as? String
                            self.golferIron.text = data.objectForKey("irons") as? String
                            self.favoriteCourse.text = data.objectForKey("favoriteCourse") as? String
                            print(data.objectForKey("username"))
                            
                            let pfImage = data.objectForKey("profileImage") as? PFFile
                            pfImage?.getDataInBackgroundWithBlock({
                                (result, error) in
                                self.golferProfileImage.image = UIImage(data: result!)
                                
                            })

                        
                        }
                        
                        
                    }
                }
        }
            
        }
            })
        }
        
    
    }
    
    @IBAction func unwindToProfilePage(segue: UIStoryboardSegue) {

    }
    
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }


}
