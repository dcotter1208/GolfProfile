//
//  FriendScorecardCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/7/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import ParseUI

class FriendScorecardCell: PFTableViewCell {
    @IBOutlet weak var friendScorecardCellGCLabel: UILabel!
    @IBOutlet weak var friendScorecardCellDateLabel: UILabel!
    @IBOutlet weak var friendScorecardCellScoreLabel: UILabel!
    @IBOutlet weak var friendScorecardImageView: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewWillLayoutSubviews()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func viewWillLayoutSubviews() {
        self.friendScorecardImageView.layer.cornerRadius = 3.0
        self.friendScorecardImageView.clipsToBounds = true
        self.friendScorecardImageView.layer.borderWidth = 1.0
        
    }
    
    
}
