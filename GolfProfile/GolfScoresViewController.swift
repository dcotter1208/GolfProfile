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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userScoreTableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
//        userScoreTableView.reloadData()
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
        
        let scorecard:PFObject = self.scorecardData.reverse()[indexPath.row] as PFObject
        
        cell.golfCourseCellLabel.text = scorecard.objectForKey("GolfCourse") as? String
        cell.dateCellLabel.text = scorecard.objectForKey("date") as? String
        cell.scoreCellLabel.text = scorecard.objectForKey("score") as? String
        
        //downcast it to a PFFIle - which is what the Parse images are stored as. I then grab the data/image in the background and it is stored as an NSData which is the (result) inside of the getDataInBackgroundWithBlock and pass it to the UIImage and set the cell's image..... UIImage(date: ____) accepts a type of NSData.
        let pfImage = scorecard.objectForKey("scorecardImage") as? PFFile
        
        pfImage!.getDataInBackgroundWithBlock({
            (result, error) in
            cell.scorecardCellImage.image = UIImage(data: result!)
        })
        

        return cell
    }
    
    func loadData() {
        //Removes all of the PFObjects from the array so when the table is reloaded that it doesn't add onto the existing objects and the same score won't be listed again.
        scorecardData.removeAll()
        
        let query = PFQuery(className: "GolfScorecard")
        query.whereKey("playerName", equalTo: PFUser.currentUser()!)
        query.orderByAscending("createdAt")
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