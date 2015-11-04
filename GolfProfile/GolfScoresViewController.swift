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
    
    @IBOutlet weak var userScoreTableView: UITableView!
    
    var scoreCardData = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userScoreTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        userScoreTableView.reloadData()
    }
//    
//    override func viewDidAppear(animated: Bool) {
//        loadData()
//        userScoreTableView.reloadData()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return scoreCardData.count
        }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UserLeaderboardCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UserLeaderboardCell
        
        let scoreCard:PFObject = self.scoreCardData.reverse()[indexPath.row] as PFObject
        
        cell.golfCourseCellLabel.text = scoreCard.objectForKey("GolfCourse") as? String
        cell.dateCellLabel.text = scoreCard.objectForKey("date") as? String
        cell.scoreCellLabel.text = scoreCard.objectForKey("score") as? String
        
        if scoreCard.objectForKey("scoreCardImage") == nil {
            cell.scorecardCellImage.image = UIImage(named: "scorecard")! as UIImage } else {
        cell.scorecardCellImage.image = scoreCard.objectForKey("scoreCardImage") as? UIImage
        }
        return cell
    }
    
    func loadData() {
        //Removes all of the PFObjects from the array so when the table is reloaded that it doesn't add onto the existing objects and the same score won't be listed again.
        scoreCardData.removeAll()
        
        let query = PFQuery(className: "GolfScore")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
            
                for object:PFObject in scoreCards! {
                    self.scoreCardData.append(object)
                    print(self.scoreCardData.count)
                }
                dispatch_async(dispatch_get_main_queue()) {
                
                self.userScoreTableView.reloadData()
                    
                }
                
            } else {
                print(error)
            }
        }
        
    }
    
    @IBAction func unwindToGameScoreVC(segue: UIStoryboardSegue) {
        userScoreTableView.reloadData()
    }


}