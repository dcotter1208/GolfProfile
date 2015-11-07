//
//  addFriendsViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/6/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addFriendsTableView: UITableView!
    
    var allUsers = [PFObject]()
    
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
        
        let cell:AddFriendCell = tableView.dequeueReusableCellWithIdentifier("addFriendCell", forIndexPath: indexPath) as! AddFriendCell
        
        let userInfo:PFObject = self.allUsers [indexPath.row] as! PFUser
        cell.userNameCellLabel.text = userInfo.objectForKey("username") as? String

        return cell
    }



    func loadData() {
        //Removes all of the PFObjects from the array so when the table is reloaded that it doesn't add onto the existing objects and the same score won't be listed again.
        allUsers.removeAll()
        
        let userQuery = PFUser.query()
            userQuery!.whereKeyExists("username")
            userQuery!.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
        
                    for object:PFObject in users! {
                    self.allUsers.append(object)
                    print(self.allUsers.count)
                        
                        
                }
            }
            
        }
        
        
    }

    
    @IBAction func reload(sender: AnyObject) {
        
        addFriendsTableView.reloadData()
    }
    
    
}
