//
//  ScorecardPhotoViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FriendScorecardDetailVC: UIViewController {

    @IBOutlet weak var friendScorecardScrollView: UIScrollView!
    @IBOutlet weak var scorecardImageView: PFImageView!
    @IBOutlet weak var friendScorecardGCLabel: UILabel!
    @IBOutlet weak var friendScorecardDateLabel: UILabel!
    @IBOutlet weak var friendScorecardScoreLabel: UILabel!
    
    var friendScorecard = GolfScorecard()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendDetailedScorecardInfo()
        
        self.friendScorecardScrollView.minimumZoomScale = 1.0
        self.friendScorecardScrollView.maximumZoomScale = 6.0
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.scorecardImageView
        
    }
    
    func loadFriendDetailedScorecardInfo() {
        
        scorecardImageView.file = friendScorecard.scorecardImage
        scorecardImageView.loadInBackground()
    
    }

}
