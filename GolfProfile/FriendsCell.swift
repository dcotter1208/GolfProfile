//
//  FriendsCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/6/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import ParseUI

class FriendsCell: PFTableViewCell {
    @IBOutlet weak var friendUserNameCellLabel: UILabel!
    @IBOutlet weak var friendProfileCell: PFImageView!
    
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
