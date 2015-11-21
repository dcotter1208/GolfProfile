//
//  GolfScoresViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse


class GolfScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userScoreboardTableView: UITableView!
    @IBOutlet weak var scoreViewSegmentedControl: UISegmentedControl!
    
    var scorecardData = [PFObject]()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userScoreboardTableView.addSubview(self.refreshControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadUserScorecardData()
        self.userScoreboardTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return scorecardData.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UserLeaderboardCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UserLeaderboardCell
                
        if let scorecard:PFObject = self.scorecardData[indexPath.row] {
        
        //Get the date from Parse and turning it into a String to display in label
       if let golfDate = scorecard.objectForKey("date") as? NSDate {
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let stringDate = dateFormatter.stringFromDate(golfDate)
            cell.dateCellLabel?.text = stringDate
        
        }
            
        //Get the score from Parse and turning it into a String to display in label
        if let score = scorecard.objectForKey("score") as? Int {
            
        let scoreToString = "\(score)"
        cell.scoreCellLabel?.text = scoreToString
            
        }
        
        cell.golfCourseCellLabel?.text = scorecard.objectForKey("golfCourse") as? String
        
        let pfImage = scorecard.objectForKey("scorecardImage") as? PFFile
        
        pfImage?.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result == nil {
                
            cell.scorecardCellImage?.image = UIImage(named: "noScorecard")
                
            } else {
                
            cell.scorecardCellImage?.image = UIImage(data: result!)
                
            }
        })
    }
        
        
        return cell
}
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let selectedScorecard:PFObject = scorecardData[indexPath.row] as PFObject
            selectedScorecard.deleteInBackground()
            scorecardData.removeAtIndex(indexPath.row)
            userScoreboardTableView.reloadData()
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showScorecardDetail" {
        
        let userScorecardDetailVC = segue.destinationViewController as? UserScorecardDetailVC
        
        let selectedIndex = userScoreboardTableView.indexPathForCell(sender as! UITableViewCell)
            
        userScorecardDetailVC?.userScorecard = scorecardData[selectedIndex!.row] as PFObject

        }
        
    }
    
    func loadUserScorecardData() {
        scorecardData.removeAll()
        
        let query = PFQuery(className: "GolfScorecard")
        query.whereKey("golfer", equalTo: PFUser.currentUser()!)
    
        query.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
            
                dispatch_async(dispatch_get_main_queue()) {
                for object:PFObject in scoreCards! {
                    self.scorecardData.append(object)
                    self.userScoreboardTableView.reloadData()
                    }
                }
                
                } else {
                
                print(error)
                
            }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {

        self.userScoreboardTableView.reloadData()
        refreshControl.endRefreshing()
        
    }

    @IBAction func scoreViewSegmentedControlPushed(sender: AnyObject) {
        
        switch (scoreViewSegmentedControl) {
        case 0:
            print("date selected")
        case 1:
            print("score selected")
        default:
            print("WHHAAAATTTT")
        }
        
    }

}