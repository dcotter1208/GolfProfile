//
//  PreviousCourseCell.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/14/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit

class PreviousCourseCell: UITableViewCell {
    @IBOutlet weak var previousCourseLabel: UILabel!

    @IBOutlet weak var previousCourseCityLabel: UILabel!
    
    @IBOutlet weak var previousCourseStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
