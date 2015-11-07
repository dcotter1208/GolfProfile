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
    var friendsRelation = PFRelation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFriendsData()
        
        navigationItem.hidesBackButton = true

        // Do any additional setup after loading the view.
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
    
        return cell
    }
    
    func loadFriendsData() {
        //This is assigning the variable friendsRelation (which is a PFRelation Type) to the current user and grabbing the current user's key of "friendsRelation"
        friendsRelation = (PFUser.currentUser()?.objectForKey("friendsRelation"))! as! PFRelation

        //queries the friendsRelation of the current user.
        let query = friendsRelation.query()
        query?.orderByAscending("username")
        query?.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object:PFObject in friends! {
                    self.friends.append(object)
                    print(self.friends.count)
                    
                self.friendsTableView.reloadData()

                }
            }
            
            
        }
        
        
    }
    


}
