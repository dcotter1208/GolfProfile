//
//  LeaderboardCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/11/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit

class LeaderboardCell: UITableViewCell {

    @IBOutlet weak var leaderboardGCLabel: UILabel!
    @IBOutlet weak var leaderboardDateLabel: UILabel!
    @IBOutlet weak var leaderboardScoreLabel: UILabel!
    @IBOutlet weak var leaderboardProfileImage: UIImageView!
    @IBOutlet weak var leaderboardGolferLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
