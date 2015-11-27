//
//  FriendScoresViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class FriendScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendScorecardTableView: UITableView!
    
    var friendScorecardData = [PFObject]()
    var selectedfriend = PFObject?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendScorecardData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendScorecardData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FriendScorecardCell = tableView.dequeueReusableCellWithIdentifier("friendScorecardCell", forIndexPath: indexPath) as! FriendScorecardCell
        
        let friendScorecard:PFObject = self.friendScorecardData[indexPath.row] as PFObject
        
        if let golfDate = friendScorecard.objectForKey("date") as? NSDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let stringDate = dateFormatter.stringFromDate(golfDate)
            cell.friendScorecardCellDateLabel?.text = stringDate
        }
        //Grabbing the score from Parse and turning it into a String to display in label
        if let score = friendScorecard.objectForKey("score") as? Int {
            let scoreToString = "\(score)"
            cell.friendScorecardCellScoreLabel?.text = scoreToString
        }

        
        cell.friendScorecardCellGCLabel.text = friendScorecard.objectForKey("golfCourse") as? String

        cell.friendScorecardImageView.image = UIImage(named: "noScorecard")
        let pfImage = friendScorecard.objectForKey("scorecardImage") as? PFFile
        
        pfImage!.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result != nil {
            
                
            cell.friendScorecardImageView.image = UIImage(data: result!)
                
            }
            
        })
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let scorecardPhotoVC = segue.destinationViewController as? FriendScorecardDetailVC
        
        let selectedIndex = friendScorecardTableView.indexPathForCell(sender as! UITableViewCell)
        
        scorecardPhotoVC?.scorecard = (friendScorecardData[(selectedIndex?.row)!] as PFObject)
        
    }
    
    
    
    func loadFriendScorecardData() {
        friendScorecardData.removeAll()
        
        let query = PFQuery(className: "GolfScorecard")
        query.whereKey("golfer", equalTo: selectedfriend!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (friendScorecards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object:PFObject in friendScorecards! {
                    self.friendScorecardData.append(object)
                    self.friendScorecardTableView.reloadData()
                }
                
                
            } else {
                print(error)
            }
        }
        
    }
    
    
}
