//
//  FriendsCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/6/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    @IBOutlet weak var friendUserNameCellLabel: UILabel!
    @IBOutlet weak var friendProfileCell: UIImageView!
    
    @IBOutlet weak var friendCountryCell: UILabel!
    
    override func awakeFromNib() {

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
