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
    var friendsRelation = PFRelation?()
    var joinedQueries = [PFQuery]()
    
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
        return friends.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:FriendsCell = tableView.dequeueReusableCellWithIdentifier("friendsCell", forIndexPath: indexPath) as! FriendsCell
        
        
        if let friendInfo:PFObject = self.friends[indexPath.row] as! PFUser {
            
            cell.friendUserNameCellLabel.text = friendInfo.objectForKey("username") as? String
            
            let pfImage = friendInfo.objectForKey("profileImage") as? PFFile
            
            pfImage?.getDataInBackgroundWithBlock({
                (result, error) in
                
                if result != nil {
                    cell.friendProfileCell.image = UIImage(data: result!)
                    cell.friendProfileCell.layer.cornerRadius = cell.friendProfileCell.frame.size.width / 2
                } else {
                    print(error)
                }
            })
        }
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEditFriends" {
            let editFriendsVC = segue.destinationViewController as! EditFriendsViewController
            
            editFriendsVC.showFriends = self.friends
            
        } else if segue.identifier == "showFriendScores"  {
            
            let friendScoresVC = segue.destinationViewController as! FriendScoresViewController
            
            let selectedIndex = friendsTableView.indexPathForCell(sender as! UITableViewCell)
            
            friendScoresVC.selectedfriend = friends[selectedIndex!.row] as PFObject
            
        }
    }
    
    func loadFriendsData() {
        friends.removeAll()

        friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation
        
        //queries the friendsRelation of the current user.
        if let userQuery = friendsRelation?.query() {
        userQuery.orderByAscending("username")
        
                userQuery.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
                    if friends != nil {
                        dispatch_async(dispatch_get_main_queue()) {
                            for object:PFObject in friends! {
                                self.friends.append(object)
                                self.friendsTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }


}
