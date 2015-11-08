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
    var selectedScorecard = PFObject?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

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
        
        cell.friendScorecardCellGCLabel.text = friendScorecard.objectForKey("GolfCourse") as? String
        cell.friendScorecardCellDateLabel.text = friendScorecard.objectForKey("date") as? String
        cell.friendScorecardCellScoreLabel.text = friendScorecard.objectForKey("score") as? String
        
        //downcast it to a PFFIle - which is what the Parse images are stored as. I then grab the data/image in the background and it is stored as an NSData which is the (result) inside of the getDataInBackgroundWithBlock and pass it to the UIImage and set the cell's image..... UIImage(date: ____) accepts a type of NSData.
        let pfImage = friendScorecard.objectForKey("scorecardImage") as? PFFile
        
        pfImage!.getDataInBackgroundWithBlock({
            (result, error) in
            
            cell.friendScorecardImageView.image = UIImage(data: result!)

        })
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedScorecard = friendScorecardData[indexPath.row]
        print("***************************")
        print(selectedScorecard)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showScorecardPhoto" {

            
            let scorecardPhotoVC = segue.destinationViewController as? ScorecardPhotoViewController
            
            scorecardPhotoVC?.scorecardData = self.friendScorecardData
            
//            scorecardPhotoVC?.scorecard = selectedScorecard!
            
//            let selectedIndex = friendScorecardTableView.indexPathForCell(sender as! UITableViewCell)
//            scorecardPhotoVC?.scorecardPhoto = friendScorecardData[(selectedIndex?.row)!] as PFFile
            
        }
    }
    
    
    
    func loadData() {
        //Removes all of the PFObjects from the array so when the table is reloaded that it doesn't add onto the existing objects and the same score won't be listed again.
        friendScorecardData.removeAll()
        
        let query = PFQuery(className: "GolfScorecard")
        query.whereKey("playerName", equalTo: selectedfriend!)
        query.orderByAscending("createdAt")
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
