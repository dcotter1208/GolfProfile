//
//  UserGolfScorecardViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfilePhotoAndScorecardPhotoVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var userScorecardImageView: PFImageView!
    @IBOutlet weak var userScorecardScrollView: UIScrollView!
    @IBOutlet weak var noScorecardImageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    var scorecard = GolfScorecard?()
    var userProfileData = [PFObject]()
    var selectedFriendProfile = GolferProfile()


    override func viewDidLoad() {
    super.viewDidLoad()
        
        if scorecard?.scorecardImage == nil {
            
            noScorecardImageView.image = UIImage(named: "noScorecardAvailable")
            noScorecardImageView.backgroundColor = UIColor.whiteColor()
            dismissButton.tintColor = UIColor.blackColor()
            
        } else {
            dismissButton.tintColor = UIColor.whiteColor()
            displayUserDetailedScorecardInfo()
            loadFriendDetailedScorecardInfo()

        }
        
    displayUserProfilePhoto()
    userScorecardImageView.file = selectedFriendProfile.profileImage

    
    self.userScorecardScrollView.minimumZoomScale = 1.0
    self.userScorecardScrollView.maximumZoomScale = 6.0
        
    }

    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissButton(sender: AnyObject) {
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
    return self.userScorecardImageView
        
    }
    
    func displayUserDetailedScorecardInfo() {

        userScorecardImageView.file = scorecard?.scorecardImage
        userScorecardImageView.loadInBackground()

    }
    
    func displayUserProfilePhoto() {
        
        for data in userProfileData {
        userScorecardImageView.file = data.objectForKey("profileImage") as? PFFile
        userScorecardImageView.loadInBackground()
            
        }

    }
    
    func loadFriendDetailedScorecardInfo() {

        userScorecardImageView.file = scorecard?.scorecardImage
        userScorecardImageView.loadInBackground()
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
}
