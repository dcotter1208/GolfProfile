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
    @IBOutlet weak var friendProfileCell: PFImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {

        viewWillLayoutSubviews()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func viewWillLayoutSubviews() {
        
        self.friendProfileCell.layer.cornerRadius = self.friendProfileCell.frame.size.width / 2
        self.friendProfileCell.clipsToBounds = true
        self.friendProfileCell.layer.borderColor = UIColor.orangeColor().CGColor
        self.friendProfileCell.layer.borderWidth = 3
        
    }

}
