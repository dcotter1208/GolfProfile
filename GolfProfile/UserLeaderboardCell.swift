//
//  UserLeaderBoTableViewCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import ParseUI

class UserLeaderboardCell: PFTableViewCell {
    @IBOutlet weak var scorecardCellImage: PFImageView!
    @IBOutlet weak var golfCourseCellLabel: UILabel!
    @IBOutlet weak var dateCellLabel: UILabel!
    @IBOutlet weak var scoreCellLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        viewWillLayoutSubviews()

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        func viewWillLayoutSubviews() {
        self.scorecardCellImage.layer.cornerRadius = 3.0
        self.scorecardCellImage.clipsToBounds = true
        self.scorecardCellImage.layer.borderWidth = 1.0
        
    }

}
