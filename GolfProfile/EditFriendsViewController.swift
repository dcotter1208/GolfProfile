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
    
    var allUsers = [PFObject]()
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
        
        let userInfo:PFObject = self.allUsers [indexPath.row] as! PFUser
        cell.userNameCellLabel.text = userInfo.objectForKey("username") as? String

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if (cell?.accessoryType == UITableViewCellAccessoryType.Checkmark) {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        } else {
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            //The following is creating a relation for the current user. tIf the relation for the current key - "friendsRelation" then it will be created for us. Otherwise the existing one will be returned.
            friendsRelation = (currentUser?.relationForKey("friendsRelation"))!
            
            
            //This method takes the object at the indexPath selected and adds it to the friends relation we just created for our current user in the line above. This saves it locally but not to the backend.
            let userInfo:PFObject = self.allUsers [indexPath.row] as! PFUser
            friendsRelation.addObject(userInfo)
            
            //This saves line saves the PFRelation to the backend. Parse.com maintains a unique identifier for each object on the backend. So a "friend" can never be added twice. 
            currentUser?.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("WE GOT FRIENDS!!!!")
                    
                } else {
                    
                    print(error)
                    
                    
                }
            }
            
            
        } else {
            
        
        }
        
    }



    func loadData() {
        //Removes all of the PFObjects from the array so when the table is reloaded that it doesn't add onto the existing objects and the same score won't be listed again.
        allUsers.removeAll()
        
        let userQuery = PFUser.query()
            userQuery?.orderByAscending("username")
            userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
        
                    for object:PFObject in users! {
                    self.allUsers.append(object)
                    print(self.allUsers.count)
                        
                      self.addFriendsTableView.reloadData()
                    }
                }
                
                
        }
        
        
    }

    
    @IBAction func reload(sender: AnyObject) {
        
        addFriendsTableView.reloadData()
    }
    
    
}
