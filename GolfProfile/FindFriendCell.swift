//
//  AddFriendCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/6/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FindFriendCell: UITableViewCell {
    @IBOutlet weak var findUsernameCellLabel: UILabel!
    @IBOutlet weak var findFriendProfileCellImage: PFImageView!
    
    @IBOutlet weak var addFollowingLabel: UILabel!

    @IBOutlet weak var checkmarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
