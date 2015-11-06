//
//  NewScoreViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class NewScoreViewController: UIViewController {
    @IBOutlet weak var golfCourseName: UITextField!
    @IBOutlet weak var gameScore: UITextField!
    @IBOutlet weak var gameDate: UITextField!
    @IBOutlet weak var scorecardImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveScoreButton(sender: AnyObject) {
        
        let imageData = UIImagePNGRepresentation(self.scorecardImage.image!)
        let parseImageFile = PFFile(name: "scorecard.png", data: imageData!)
        
        let golfScore = PFObject(className:"GolfScorecard")
        golfScore["score"] = gameScore.text!
        golfScore["playerName"] = PFUser.currentUser()
        golfScore["GolfCourse"] = golfCourseName.text!
        golfScore["date"] = gameDate.text!
        golfScore["scorecardImage"] = parseImageFile
        golfScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                
            } else {
                
                
                
                
            }
        }
        
        
    }


    
    

}
