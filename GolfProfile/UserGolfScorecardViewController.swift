//
//  UserGolfScorecardViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/8/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class UserGolfScorecardViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var golfCourseNameLabel: UILabel!
    @IBOutlet weak var scorecardScoreLabel: UILabel!
    @IBOutlet weak var scorecardDateLabel: UILabel!
    @IBOutlet weak var userScorecardImageView: UIImageView!
    
    @IBOutlet weak var userScorecardScrollView: UIScrollView!
    var userScorecard = PFObject?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setZoomScale()
//        
//        userScorecardScrollView = UIScrollView(frame: view.bounds)
//        userScorecardScrollView.backgroundColor = UIColor.blackColor()
//        userScorecardScrollView.contentSize = userScorecardImageView.bounds.size
//        userScorecardScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        userScorecardScrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//        userScorecardScrollView.contentOffset = CGPoint(x: 1000, y: 450)
//        
//        userScorecardScrollView.addSubview(userScorecardImageView)
//        view.addSubview(userScorecardScrollView)
        
        self.userScorecardScrollView.minimumZoomScale = 1.0
        self.userScorecardScrollView.maximumZoomScale = 6.0
        self.userScorecardScrollView.zoomScale = 1.0

        
        //Getting the date from Parse and turning it into a String to display in label
        if let golfDate = userScorecard?.objectForKey("date") as? NSDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let stringDate = dateFormatter.stringFromDate(golfDate)
            scorecardDateLabel.text = stringDate
        }
//        Grabbing the score from Parse and turning it into a String to display in label
        if let score = userScorecard?.objectForKey("score") as? Int {
            let scoreToString = "\(score)"
            scorecardScoreLabel.text = scoreToString
        }

        golfCourseNameLabel.text = userScorecard?.objectForKey("golfCourse") as? String
        let pfImage = userScorecard!.objectForKey("scorecardImage") as? PFFile
        
        pfImage?.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result == nil {
                
                self.userScorecardImageView.image = UIImage(named: "noScorecard")
                
            } else {
                self.userScorecardImageView.image = UIImage(data: result!)
            }
        })
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func dismissButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.view
    }
    
    //Get the width and height ratios and pick the smaller of the two and set it as the minimum zoom scale.
//    func setZoomScale() {
//        let imageViewSize = userScorecardImageView.bounds.size
//        let scrollViewSize = userScorecardScrollView.bounds.size
//        let widthScale = scrollViewSize.width / imageViewSize.width
//        let heightScale = scrollViewSize.height / imageViewSize.height
//        
//        userScorecardScrollView.minimumZoomScale = min(widthScale, heightScale)
//        userScorecardScrollView.zoomScale = 1.0
//    }
//    
//    //This function makes the image scales right after the user tries to zoom in/out after a device orientation change.
//    override func viewWillLayoutSubviews() {
//        setZoomScale()
//    }


}
