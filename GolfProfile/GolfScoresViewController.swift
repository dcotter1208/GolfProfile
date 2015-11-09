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
    
    var scorecardData = [PFObject]()
    var dateFormatter = NSDateFormatter()
    var date = NSDate?()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()

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
        
        let scorecard:PFObject = self.scorecardData[indexPath.row] as PFObject
        

        //Getting the date from Parse and turning it into a String to display in label
       if let golfDate = scorecard.objectForKey("date") as? NSDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let stringDate = dateFormatter.stringFromDate(golfDate)
            cell.dateCellLabel.text = stringDate
        }
        //Grabbing the score from Parse and turning it into a String to display in label
        if let score = scorecard.objectForKey("score") as? Int {
        let scoreToString = "\(score)"
        cell.scoreCellLabel.text = scoreToString
        }
        
        cell.golfCourseCellLabel.text = scorecard.objectForKey("golfCourse") as? String
        
        
        //downcast it to a PFFIle - which is what the Parse images are stored as. I then grab the data/image in the background and it is stored as an NSData which is the (result) inside of the getDataInBackgroundWithBlock and pass it to the UIImage and set the cell's image..... UIImage(date: ____) accepts a type of NSData.
        let pfImage = scorecard.objectForKey("scorecardImage") as? PFFile
        
        pfImage?.getDataInBackgroundWithBlock({
            (result, error) in
            
            if result == nil {
            cell.scorecardCellImage.image = UIImage(named: "noScorecard")
                
            } else {
                cell.scorecardCellImage.image = UIImage(data: result!)
            }
        })
        

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
        
        let userScorecardPhotoVC = segue.destinationViewController as? UserGolfScorecardViewController
        
        let selectedIndex = userScoreboardTableView.indexPathForCell(sender as! UITableViewCell)
        
        userScorecardPhotoVC?.userScorecard = (scorecardData[(selectedIndex?.row)!] as PFObject)
        
        }
        
    }
    
    func loadData() {
        //Removes all of the PFObjects from the array so when the table is reloaded that it doesn't add onto the existing objects and the same score won't be listed again.
        scorecardData.removeAll()
        
        let query = PFQuery(className: "GolfScorecard")
        query.whereKey("golfer", equalTo: PFUser.currentUser()!)
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
            
                for object:PFObject in scoreCards! {
                    self.scorecardData.append(object)
                    self.userScoreboardTableView.reloadData()
                }
                
                
            } else {
                print(error)
            }
        }
        
    }
    
    @IBAction func unwindToGameScoreVC(segue: UIStoryboardSegue) {
        
    }


}