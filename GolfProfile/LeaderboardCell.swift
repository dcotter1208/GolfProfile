//
//  LeaderboardCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/11/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import ParseUI

class LeaderboardCell: UITableViewCell {

    @IBOutlet weak var leaderboardGCLabel: UILabel!
    @IBOutlet weak var leaderboardDateLabel: UILabel!
    @IBOutlet weak var leaderboardScoreLabel: UILabel!
    @IBOutlet weak var leaderboardProfileImage: PFImageView!
    @IBOutlet weak var leaderboardGolferLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewWillLayoutSubviews()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func viewWillLayoutSubviews() {
        
        self.leaderboardGCLabel.layer.cornerRadius = 3.0
        self.leaderboardGCLabel.layer.borderWidth = 2.0
        self.leaderboardGCLabel.layer.borderColor = UIColor.blackColor().CGColor
        self.leaderboardScoreLabel.layer.cornerRadius = 3.0
        self.leaderboardScoreLabel.layer.borderWidth = 2.0
        self.leaderboardScoreLabel.layer.borderColor = UIColor.blackColor().CGColor
        self.leaderboardProfileImage.layer.cornerRadius = self.leaderboardProfileImage.frame.size.width / 2
        self.leaderboardProfileImage.clipsToBounds = true
        self.leaderboardProfileImage.layer.borderColor = UIColor.orangeColor().CGColor
        self.leaderboardProfileImage.layer.borderWidth = 3
        
        
    }

}
