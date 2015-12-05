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

class EditFriendCell: UITableViewCell {
    @IBOutlet weak var userNameCellLabel: UILabel!

    @IBOutlet weak var editFriendProfileCellImage: PFImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
