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

    var scoreCardImages = [PFFile]()
    var golfCourseNames = [String]()
    var scores = [String]()
    var dates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let query = PFQuery(className: "GolfScore")
//        query.orderByAscending("createdAt")
//        query.findObjectsInBackgroundWithBlock { (scoreCards: [PFObject]?, error: NSError?) -> Void in
//            if error == nil {
//                
//                for scoreCardInfo in scoreCards! {
//                    self.scoreCardImages.append(scoreCardInfo.objectForKey("scoreCardImage") as! PFFile)
//                    self.golfCourseNames.append(scoreCardInfo.objectForKey("GolfCourse") as! String)
//                    self.scores.append(scoreCardInfo.objectForKey("score") as! String)
//                    self.dates.append(scoreCardInfo.objectForKey("date") as! String)
//                }
//                    self.userScoreTableView.reloadData()
//            } else {
//                print(error)
//            }
//        }

    }
    
    override func viewWillAppear(animated: Bool) {
        userScoreTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return scores.count

        }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = scores[indexPath.row]
        
        
        return cell
    }
    


}