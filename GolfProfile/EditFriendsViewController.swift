//
//  addFriendsViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/6/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class EditFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addFriendsTableView: UITableView!
    
    @IBOutlet weak var editFriendProfileImage: UIImageView!
    
    var allUsers = [PFObject]()
    var showFriends = [PFObject]()
    var friendsRelation = PFRelation()
    let currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        addFriendsTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:EditFriendCell = tableView.dequeueReusableCellWithIdentifier("editFriendCell", forIndexPath: indexPath) as! EditFriendCell
        
        let userInfo:PFObject = self.allUsers[indexPath.row] as! PFUser
        cell.userNameCellLabel.text = userInfo.objectForKey("username") as? String
        
        
        //THIS NEEDS TO BE CHANGED ONCE I GET THE PROFILE IMAGE FROM PARSE WORKING
        cell.editFriendProfileCellImage.image = UIImage(named: "defaultUser")
        
        //if the user is a friend then their name will have a checkmark
        if isFriend(userInfo as! PFUser) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        friendsRelation = (PFUser.currentUser()?.relationForKey("friendsRelation"))!
        let userInfo:PFObject = self.allUsers[indexPath.row] as! PFUser
        
        if isFriend(userInfo as! PFUser) {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
            for friend in showFriends{
                if friend.objectId == userInfo.objectId {
                    friendsRelation.removeObject(friend)
                }
            }
            
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            showFriends.append(userInfo)
            friendsRelation.addObject(userInfo)
        }
                    currentUser?.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            print("WE GOT FRIENDS!!!!")
        
                        } else {
                            print(error)
                    }
            }
    }
    
    //Function that loads all of my PFUsers
    func loadData() {
        allUsers.removeAll()
        
        let userQuery = PFUser.query()
            userQuery?.orderByAscending("username")
            userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
        
                    for object:PFObject in users! {
                    self.allUsers.append(object)
                    self.addFriendsTableView.reloadData()
                    }
                }
            }
        }

//Function to check of a user is a or isn't a current friend. If they are then we are using this method to display a checkmark by their name in our editFriendsVC
    func isFriend(user: PFUser) -> Bool {
        for friend in showFriends {
            if friend.objectId == user.objectId {
                return true
            } 
        
        }
        
        return false
    
    }
    
    
}
