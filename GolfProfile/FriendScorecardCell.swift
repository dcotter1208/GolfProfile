//
//  FriendScorecardCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/7/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit

class FriendScorecardCell: UITableViewCell {
    @IBOutlet weak var friendScorecardCellGCLabel: UILabel!
    @IBOutlet weak var friendScorecardCellDateLabel: UILabel!
    @IBOutlet weak var friendScorecardCellScoreLabel: UILabel!
    
    @IBOutlet weak var friendScorecardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
