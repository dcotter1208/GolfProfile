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

    var friendScorecardData = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let cell:FriendScorecardCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! FriendScorecardCell
        
        let scorecard:PFObject = self.friendScorecardData.reverse()[indexPath.row] as PFObject
        
        cell.friendScorecardCellGCLabel.text = scorecard.objectForKey("GolfCourse") as? String
        cell.friendScorecardCellDateLabel.text = scorecard.objectForKey("date") as? String
        cell.friendScorecardCellScoreLabel.text = scorecard.objectForKey("score") as? String
        
        //downcast it to a PFFIle - which is what the Parse images are stored as. I then grab the data/image in the background and it is stored as an NSData which is the (result) inside of the getDataInBackgroundWithBlock and pass it to the UIImage and set the cell's image..... UIImage(date: ____) accepts a type of NSData.
        let pfImage = scorecard.objectForKey("scorecardImage") as? PFFile
        
        pfImage!.getDataInBackgroundWithBlock({
            (result, error) in
            cell.friendScorecardImageView.image = UIImage(data: result!)
        })
        
        
        return cell
    }
    


}
