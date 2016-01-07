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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    var leaderboardData = [(GolfScorecard, GolferProfile)]()
    var friendsRelation = PFRelation?()
    var golferInfo = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (_,i) in leaderboardData {
        
            if PFUser.currentUser()?.username == i.username {
            
                
            
            }
        
        }
        
        
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
        
        if let allScorecards:(GolfScorecard, GolferProfile) = self.leaderboardData[indexPath.row] {
        

            cell.rankLabel.text = "\(indexPath.row + 1)"
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            cell.leaderboardDateLabel?.text = dateFormatter.stringFromDate(allScorecards.0.date)
        
            cell.leaderboardScoreLabel?.text = "\(allScorecards.0.score)"

            allScorecards.1.fetchIfNeededInBackgroundWithBlock({ (info: PFObject?, error: NSError?) -> Void in
            
            cell.leaderboardGCLabel?.text = allScorecards.0.golfCourse
            cell.leaderboardGolferLabel.text = allScorecards.1.name
            cell.leaderboardProfileImage.file = allScorecards.1.profileImage
            cell.leaderboardProfileImage.loadInBackground()
                

            })
        
        }
        
        return cell
    }
    
    func loadLeaderboardData() {
        activityIndicator.startAnimating()
        leaderboardData.removeAll()
        
        friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation
        let friendQuery = friendsRelation?.query()
        let friendScorecardQuery = PFQuery(className: "GolfScorecard")
        friendScorecardQuery.whereKey("golfer", matchesQuery: friendQuery!)
        let currentUserScorecardQuery = PFQuery(className: "GolfScorecard")
        currentUserScorecardQuery.whereKey("golfer", equalTo: PFUser.currentUser()!)
        let subQuery = PFQuery.orQueryWithSubqueries([friendScorecardQuery, currentUserScorecardQuery])
        subQuery.orderByAscending("score")
        subQuery.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
            self.activityIndicator.stopAnimating()
            for object:PFObject in scoreCards! {
                if let object = object as? GolfScorecard {
                if let golfer = object["golfer"] as? GolferProfile {
                self.leaderboardData.append(object,golfer)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                    
                        self.leaderboardTableView.reloadData()
                        
                        }
                    }
                }

                }
                
            } else {
                self.activityIndicator.stopAnimating()
                print(error)
        }
    }
}
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.leaderboardTableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
}
