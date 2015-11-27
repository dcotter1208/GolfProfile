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
    
    var scorecardData = [GolfScorecard]()
    
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

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"

        cell.dateCellLabel?.text = dateFormatter.stringFromDate(scorecardData[indexPath.row].date)

        cell.scoreCellLabel?.text = "\(scorecardData[indexPath.row].score)"
        
        cell.golfCourseCellLabel?.text = scorecardData[indexPath.row].golfCourse
        
        cell.scorecardCellImage.image = UIImage(named: "noScorecard")
        cell.scorecardCellImage.file = scorecardData[indexPath.row].scorecardImage
        cell.scorecardCellImage.loadInBackground()
        
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
        
        let query = GolfScorecard.query()
        query!.whereKey("golfer", equalTo: PFUser.currentUser()!)
        query?.orderByDescending("date")
        query!.findObjectsInBackgroundWithBlock { (scorecards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object:PFObject in scorecards! {
                    if let object = object as? GolfScorecard {
                        self.scorecardData.append(object)

                    }

                }
            
                dispatch_async(dispatch_get_main_queue()) {

                    self.userScoreboardTableView.reloadData()
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
        
        switch (scoreViewSegmentedControl.selectedSegmentIndex) {
        case 0:
            print("date")
            scorecardData.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
            userScoreboardTableView.reloadData()
            
        case 1:
            print("low score")
            
            scorecardData.sortInPlace({$0.score < $1.score})
            userScoreboardTableView.reloadData()
            
        case 2:
            print("high score")
            scorecardData.sortInPlace({$0.score > $1.score})
            userScoreboardTableView.reloadData()

        default:
            print("ERROR")
        }
        
    }

}