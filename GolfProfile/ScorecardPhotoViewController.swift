//
//  ScorecardPhotoViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class ScorecardPhotoViewController: UIViewController {

    @IBOutlet weak var scorecardImageView: UIImageView!
    
    var scorecardData = [PFObject]()
    var scorecard = PFObject?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let pfImage = scorecard.objectForKey("scorecardImage") as? PFFile
//        
//        pfImage!.getDataInBackgroundWithBlock({
//            (result, error) in
//            
//            if result != nil {
//            
//            self.scorecardImageView.image = UIImage(data: result!)
//                
//            }
//        })
        
//        let imageFile:PFFile = scorecard.objectForKey("scorecardImage") as! PFFile
//        
//        
        print(scorecardData.count)
        print(scorecard)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
