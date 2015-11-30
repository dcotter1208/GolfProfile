//
//  FriendsViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var friendsTableView: UITableView!
    
    var friendsData = [GolferProfile]()
    var friendsRelation = PFRelation?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewWillAppear(animated: Bool) {
        loadFriendsData()
        self.friendsTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsData.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FriendsCell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! FriendsCell

            cell.friendUserNameCellLabel.text = friendsData[indexPath.row].username
            
            cell.friendProfileCell.layer.cornerRadius = cell.friendProfileCell.frame.size.width / 2
            cell.friendProfileCell.image = UIImage(named: "defaultUser")
            cell.friendProfileCell.file = friendsData[indexPath.row].profileImage
            cell.friendProfileCell.loadInBackground()

        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditFriends" {
            let editFriendsVC = segue.destinationViewController as! EditFriendsViewController
            
            editFriendsVC.showFriends = self.friendsData
            
        } else if segue.identifier == "showFriendScores"  {
            
            let friendScoresVC = segue.destinationViewController as! FriendScoresViewController
            
            let selectedIndex = friendsTableView.indexPathForCell(sender as! UITableViewCell)
            
            friendScoresVC.selectedfriend = friendsData[selectedIndex!.row]
            
        }
    }
    
    func loadFriendsData() {
        friendsData.removeAll()
        friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation
        if let userQuery = friendsRelation?.query() {
        userQuery.orderByAscending("username")
        
            userQuery.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
                if friends != nil {
                        
                    for object:PFObject in friends! {
                        if let object = object as? GolferProfile {
                            self.friendsData.append(object)
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                                self.friendsTableView.reloadData()
                            }
                        }
                    }
                }
            }
    
    
}



