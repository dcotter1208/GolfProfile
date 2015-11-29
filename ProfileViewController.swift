//
//  ProfileViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var golferNameLabel: UILabel!
    @IBOutlet weak var golferAge: UILabel!
    @IBOutlet weak var golferCountry: UILabel!
    @IBOutlet weak var golferDriver: UILabel!
    @IBOutlet weak var golferIron: UILabel!
    @IBOutlet weak var favoriteCourse: UILabel!
    @IBOutlet weak var golferProfileImage: PFImageView!
    
    var profileData = [GolferProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if PFUser.currentUser() == nil {
            
            self.performSegueWithIdentifier("showLogin", sender: self)
            
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
        
    }
    
    @IBAction func unwindToProfilePage(segue: UIStoryboardSegue) {

        getProfileFromBackground()

        
    }
    
    override func viewWillLayoutSubviews() {
        self.golferProfileImage.layer.cornerRadius = self.golferProfileImage.frame.size.width / 2
        self.golferProfileImage.layer.borderWidth = 3.0
        self.golferProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.golferProfileImage.clipsToBounds = true
        
    }
    
    func getProfileFromBackground() {
        profileData.removeAll()
        if let userQuery = PFUser.query() {
            userQuery.findObjectsInBackgroundWithBlock({ (userProfiles:[PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object:PFObject in userProfiles! {
                        if let profile = object as? GolferProfile {
                            if profile.objectId == PFUser.currentUser()?.objectId {
                            self.profileData.append(profile)
                                for data in self.profileData {
                                    self.golferNameLabel.text = data.name
                                    self.golferAge.text = "\(data.age)"
                                    self.golferCountry.text = data.country
                                    self.golferDriver.text = data.driver
                                    self.golferIron.text = data.irons
                                    self.favoriteCourse.text = data.favoriteCourse
                                    self.golferProfileImage.file = data.profileImage
                                    self.golferProfileImage.loadInBackground()
                                    
                                }
                            }

                        }
                        
                    }
                    
                } else {
                    print(error)
                
                }
            })
        }
    }
    
    
}
