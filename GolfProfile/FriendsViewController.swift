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

    var friends = [PFObject]()
    var profiles = [PFObject]()
    var friendsRelation = PFRelation?()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func viewWillAppear(animated: Bool) {
            loadFriendsData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FriendsCell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! FriendsCell
        
        let friendInfo:PFObject = self.friends[indexPath.row] as! PFUser
        cell.friendUserNameCellLabel.text = friendInfo.objectForKey("username") as? String
        
//        let profileInfo = self.f
        
        
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditFriends" {
            let editFriendsVC = segue.destinationViewController as! EditFriendsViewController
            
            editFriendsVC.showFriends = self.friends

        } else if segue.identifier == "showFriendScores"  {
            
                let friendScoresVC = segue.destinationViewController as! FriendScoresViewController
                
                let selectedIndex = friendsTableView.indexPathForCell(sender as! UITableViewCell)
                
                friendScoresVC.selectedfriend = (friends[(selectedIndex?.row)!] as PFObject)
        
        }
    }
    
    func loadFriendsData() {
        friends.removeAll()
//        profiles.removeAll()
        
        //This is assigning the variable friendsRelation (which is a PFRelation Type) to the current user and grabbing the current user's key of "friendsRelation"

        friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation
        
        //queries the friendsRelation of the current user.
        let userQuery = friendsRelation?.query()
        userQuery?.orderByAscending("username")
        
        //Grabbing profile data only associated with the friends I get aback from the userQuery
//        let profileQuery = PFQuery(className:"GolfProfile")
//        profileQuery.whereKey("user", matchesQuery: userQuery!)
        userQuery?.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object:PFObject in friends! {
                self.friends.append(object)
                self.friendsTableView.reloadData()

                print("printing friends \(self.friends.count)")
                    
//                    profileQuery.findObjectsInBackgroundWithBlock { ( profileInfo: [PFObject]?, error: NSError?) -> Void in
//                        if error == nil {
//                            for object:PFObject in profileInfo! {
//                                self.profiles.append(object)
//                                print("printing profiles \(self.profiles.count)")
//
//
//                            }
//                        }
//                    }

                }
                
            }

        }
        
    }
    
    
}
