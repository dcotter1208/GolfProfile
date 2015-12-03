//
//  FriendScoresViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FriendScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var friendProfileNameLabel: UILabel!
    @IBOutlet weak var friendProfileUsernameLabel: UILabel!
    @IBOutlet weak var friendProfileCountryLabel: UILabel!
    @IBOutlet weak var friendProfilePhoto: PFImageView!
    @IBOutlet weak var friendScorecardTableView: UITableView!
    
    @IBOutlet weak var friendScorecardSegmentedControl: UISegmentedControl!
    
    
    var friendScorecardData = [GolfScorecard]()
    var selectedfriend = GolferProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendProfile()


    }
    
    override func viewWillAppear(animated: Bool) {
        loadFriendScorecardData()
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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        cell.friendScorecardCellDateLabel.text = dateFormatter.stringFromDate(friendScorecardData[indexPath.row].date)
        
        cell.friendScorecardCellScoreLabel.text = "\(friendScorecardData[indexPath.row].score)"
        
        cell.friendScorecardCellGCLabel.text = friendScorecardData[indexPath.row].golfCourse
        
        cell.friendScorecardImageView.image = UIImage(named: "noScorecard")
        cell.friendScorecardImageView.file = friendScorecardData[indexPath.row].scorecardImage
        cell.friendScorecardImageView.loadInBackground()

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showFriendProfilePhoto" {
            let friendProfilePhotoVC = segue.destinationViewController as! ProfilePhotoVC
            
            friendProfilePhotoVC.selectedFriendProfile = selectedfriend
            
        } else {
        
        let scorecardPhotoVC = segue.destinationViewController as? FriendScorecardDetailVC
        
        let selectedIndex = friendScorecardTableView.indexPathForCell(sender as! UITableViewCell)
        
        scorecardPhotoVC?.friendScorecard = friendScorecardData[selectedIndex!.row]
            
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        self.friendProfilePhoto.layer.cornerRadius = self.friendProfilePhoto.frame.size.width / 2
        self.friendProfilePhoto.layer.borderWidth = 3.0
        self.friendProfilePhoto.layer.borderColor = UIColor.whiteColor().CGColor
        self.friendProfilePhoto.clipsToBounds = true
        
    }
    
    
    func loadFriendScorecardData() {
        friendScorecardData.removeAll()
        
        if let query = GolfScorecard.query() {
        query.whereKey("golfer", equalTo: selectedfriend)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (friendScorecards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object:PFObject in friendScorecards! {
                    if let scorecard = object as? GolfScorecard {
                        self.friendScorecardData.append(scorecard)
                        self.friendScorecardTableView.reloadData()
                    }
                
                }
            } else {
                print(error)
            }
        }
        }
    }
    
    func loadFriendProfile() {
        friendProfileNameLabel.text = selectedfriend.name
        friendProfileUsernameLabel.text = selectedfriend.username
        friendProfileCountryLabel.text = selectedfriend.country
        friendProfilePhoto.file = selectedfriend.profileImage
    }
    
    @IBAction func segmentedControl(sender: UISegmentedControl) {
        
        switch friendScorecardSegmentedControl.selectedSegmentIndex {
        
            case 0:
            friendScorecardData.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
                friendScorecardTableView.reloadData()
            
        case 1:
            friendScorecardData.sortInPlace({$0.score < $1.score})
            friendScorecardTableView.reloadData()
            
        case 2:
            friendScorecardData.sortInPlace({$0.score > $1.score})
            friendScorecardTableView.reloadData()
        
        default:
            print("ERROR")
            
        }
        
        
    }
    
    
    
    
}
