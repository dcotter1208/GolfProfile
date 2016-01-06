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
    @IBOutlet weak var findFriendProfileCellImage: PFImageView!
    @IBOutlet weak var addFollowingLabel: UILabel!
    @IBOutlet weak var findFriendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewWillLayoutSubviews()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func viewWillLayoutSubviews() {
        
        self.findFriendProfileCellImage.layer.cornerRadius = self.findFriendProfileCellImage.frame.size.width / 2
        self.findFriendProfileCellImage.clipsToBounds = true
        self.findFriendProfileCellImage.layer.borderColor = UIColor.orangeColor().CGColor
        self.findFriendProfileCellImage.layer.borderWidth = 3
        
    }


}
