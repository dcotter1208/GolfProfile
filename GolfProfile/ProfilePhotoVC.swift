//
//  ProfilePhotoVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfilePhotoVC: UIViewController {

    @IBOutlet weak var profilePhotoImageView: PFImageView!
    
    
    var userProfileData = [PFObject]()
    var selectedFriendProfile = GolferProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for data in userProfileData {
            profilePhotoImageView.file = data.objectForKey("profileImage") as? PFFile
            profilePhotoImageView.loadInBackground()
        
        }
        
        profilePhotoImageView.file = selectedFriendProfile.profileImage

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

        
    }

}
