//
//  LeaderboardViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/11/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var leaderboardTableView: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var leaderboardData = [(PFObject, PFObject)]()
    var friendsRelation = PFRelation?()
    var golferInfo = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.leaderboardTableView.addSubview(self.refreshControl)

        loadLeaderboardData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:LeaderboardCell = tableView.dequeueReusableCellWithIdentifier("leaderboardCell", forIndexPath: indexPath) as! LeaderboardCell
        
        if let allScorecards:(PFObject, PFObject) = self.leaderboardData[indexPath.row] {
            
            //Getting the data from Parse and turning it into a String to display in label
            if let golfDate = allScorecards.0.objectForKey("date") as? NSDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let stringDate = dateFormatter.stringFromDate(golfDate)
                cell.leaderboardDateLabel?.text = stringDate
            }
            //Grabbing the score from Parse and turning it into a String to display in label
            if let score = allScorecards.0.objectForKey("score") as? Int {
                let scoreToString = "\(score)"
                cell.leaderboardScoreLabel?.text = scoreToString
            }
            
            cell.leaderboardGCLabel?.text = allScorecards.0.objectForKey("golfCourse") as? String
            cell.leaderboardGolferLabel.text = allScorecards.1.objectForKey("username") as? String
            
            let pfImage = allScorecards.1.objectForKey("profileImage") as? PFFile
            
            pfImage?.getDataInBackgroundWithBlock({
                (result, error) in
                
                if result != nil {
                    
                    cell.leaderboardProfileImage.image = UIImage(data: result!)
                    cell.leaderboardProfileImage.layer.cornerRadius = cell.leaderboardProfileImage.frame.size.width / 2
                    
                } else {
                    
                    print(error)
                    
                }
            })

        }
        
//        if let golfer:PFObject = self.golferInfo[indexPath.row] {
//            
//            cell.leaderboardGolferLabel.text = golfer.objectForKey("username") as? String
        

//        }
        return cell
    }
    
    func loadLeaderboardData() {
        leaderboardData.removeAll()
        golferInfo.removeAll()
        
        friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation
        let friendQuery = friendsRelation?.query()
        let query = PFQuery(className: "GolfScorecard")
        query.whereKey("golfer", matchesQuery: friendQuery!)
        query.includeKey("golfer")
        
        query.orderByAscending("score")
        
        query.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                    for object:PFObject in scoreCards! {
                        let golfer:PFObject = object["golfer"] as! PFObject
                        self.leaderboardData.append(object,golfer)
                        print(self.leaderboardData)
//                        self.golferInfo.append(golfer)
//                        print(self.golferInfo)
                        
                        dispatch_async(dispatch_get_main_queue()) {

                        self.leaderboardTableView.reloadData()
                        }
                    }
                
            } else {
                print(error)
        }
    }
}
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.leaderboardTableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
}
