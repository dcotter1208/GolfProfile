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
    var profiles = [PFObject]()
    var friends = [PFObject]()
    var friendsRelation = PFRelation?()
    var joinedQueries = [PFQuery]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() == nil {
            friendsTableView.reloadData()
            print("THIS IS THE PRINT FOR THE FRIENDSVC:\(PFUser.currentUser())")

        }
        
    }

    override func viewWillAppear(animated: Bool) {
        loadFriendsData()
        friendsTableView.reloadData()
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
        
            print(self.profiles.count)
            if let profileInfo:PFObject = self.profiles[indexPath.row] as PFObject {
                
                let pfImage = profileInfo.objectForKey("profileImage") as? PFFile
                
                pfImage?.getDataInBackgroundWithBlock({
                    (result, error) in
                    
                    if result != nil {
                        cell.friendProfileCell.image = UIImage(data: result!)
                        
                    } else {
                        print(error)
                    }
                })
                
                
        }
        
        if let friendInfo:PFObject = self.friends[indexPath.row] as! PFUser {
            
            cell.friendUserNameCellLabel.text = friendInfo.objectForKey("username") as? String
            
            
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
                
                friendScoresVC.selectedfriend = (friends[(selectedIndex?.row)!] as PFObject)
        
        }
    }
    
    func loadFriendsData() {
        friends.removeAll()
        profiles.removeAll()
        
        //This is assigning the variable friendsRelation (which is a PFRelation Type) to the current user and grabbing the current user's key of "friendsRelation"

        friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation
        
        //queries the friendsRelation of the current user.
        let userQuery = friendsRelation?.query()
        userQuery?.orderByAscending("username")
        let profileQuery = PFQuery(className:"GolfProfile")
        profileQuery.whereKey("user", matchesQuery: userQuery!)
        
        profileQuery.findObjectsInBackgroundWithBlock { (profiles: [PFObject]?, error: NSError?) -> Void in
            if profiles != nil {
                print("Profile query run")
                for object:PFObject in profiles! {
                self.profiles.append(object)
                print("profiles: \(self.profiles.count)")
                self.friendsTableView.reloadData()
                }
                userQuery?.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
                    if friends != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                    for object:PFObject in friends! {
                    self.friends.append(object)
                    self.friendsTableView.reloadData()
                    print("friends: \(self.friends.count)")
                                }
                            }
                        }
                    }
              }
            }
                
            }

        }
        



