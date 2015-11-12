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
    
    var leaderboardData = [PFObject]()

    @IBOutlet weak var leaderboardTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLeaderboardData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:LeaderboardCell = tableView.dequeueReusableCellWithIdentifier("leaderboardCell", forIndexPath: indexPath) as! LeaderboardCell
        
        if let allScorecards:PFObject = self.leaderboardData[indexPath.row] as PFObject {
            
            
            //Getting the data from Parse and turning it into a String to display in label
            if let golfDate = allScorecards.objectForKey("date") as? NSDate {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyyy"
                let stringDate = dateFormatter.stringFromDate(golfDate)
                cell.leaderboardDateLabel?.text = stringDate
            }
            //Grabbing the score from Parse and turning it into a String to display in label
            if let score = allScorecards.objectForKey("score") as? Int {
                let scoreToString = "\(score)"
                cell.leaderboardScoreLabel?.text = scoreToString
            }
            
            cell.leaderboardGCLabel?.text = allScorecards.objectForKey("golfCourse") as? String
            cell.leaderboardGolferLabel.text = allScorecards.objectForKey("golfer") as? String
            
            let pfImage = allScorecards.objectForKey("scorecardImage") as? PFFile
            
            pfImage?.getDataInBackgroundWithBlock({
                (result, error) in
                
                if result == nil {
                    cell.leaderboardScorecardImage.image = UIImage(named: "noScorecard")
                    
                } else {
                    cell.leaderboardScorecardImage.image = UIImage(data: result!)
                }
            })
        }
        
        return cell
    }
    

    func loadLeaderboardData() {
        leaderboardData.removeAll()
        let query = PFQuery(className: "GolfScorecard")
        query.includeKey("golfer")
        print(query)
        query.orderByAscending("score")
        
        query.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    for object:PFObject in scoreCards! {
                        self.leaderboardData.append(object)
                        print(self.leaderboardData)
                        self.leaderboardTableView.reloadData()
                    }
                }
                
            } else {
                print(error)
            }
        }
        
    }


}
