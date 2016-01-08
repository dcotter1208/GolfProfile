//
//  addFriendsViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/6/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FriendsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    var allNonFriendUsers = [GolferProfile]()
    var filteredUsers = [GolferProfile]()
    var friendsData = [GolferProfile]()
    var friendsRelation = PFRelation()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadFriendsData()
        loadUserData()
        configureSearchController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            
        return filteredUsers.count
            
        } else {
        
        return friendsData.count
            
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if shouldShowSearchResults {

        let findFriendCell: FindFriendCell = tableView.dequeueReusableCellWithIdentifier("findFriendsCell", forIndexPath: indexPath) as! FindFriendCell
        findFriendCell.tintColor = UIColor.whiteColor()
        findFriendCell.findFriendName.text = filteredUsers[indexPath.row].name
        
        findFriendCell.findFriendProfileCellImage.file = filteredUsers[indexPath.row].profileImage
        findFriendCell.findFriendProfileCellImage.loadInBackground()

         return findFriendCell
            
        } else {
        
        let friendCell:FriendsCell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendsCell
            
        friendCell.tintColor = UIColor.whiteColor()
        friendCell.friendName.text = friendsData[indexPath.row].name
        friendCell.friendProfileCell.file = friendsData[indexPath.row].profileImage
        friendCell.friendProfileCell.loadInBackground()

        return friendCell
            
        }

    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return !searchController.active
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let friendToDelete = friendsData[indexPath.row]
        let relation: PFRelation = PFUser.currentUser()!.relationForKey("friendsRelation")

        if editingStyle == UITableViewCellEditingStyle.Delete {
            relation.removeObject(friendToDelete)
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if error != nil {
                    self.displayAlert(nil, message: "Failed to remove \(friendToDelete.name) as a friend", actionTitle: "OK")
                }
            })
            
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to remove \(friendToDelete.name) as a friend?", preferredStyle: .Alert)
        let cancelRemoveFriendAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let removeFriendAction = UIAlertAction(title: "Yes", style: .Default, handler: { (UIAlertAction) -> Void in
        self.allNonFriendUsers.append(friendToDelete)
        self.friendsData = self.friendsData.filter({ $0 != friendToDelete })
        self.friendsTableView.reloadData()
                
        })
            
        alertController.addAction(cancelRemoveFriendAction)
        alertController.addAction(removeFriendAction)
        self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showFriendProfileVC"  {
            
            let friendScoresVC = segue.destinationViewController as! FriendProfileViewController
            let selectedIndex = friendsTableView.indexPathForCell(sender as! UITableViewCell)
            
            friendScoresVC.selectedFriend = friendsData[selectedIndex!.row]

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if shouldShowSearchResults {
            
        let user = self.filteredUsers[indexPath.row]
        let relation: PFRelation = PFUser.currentUser()!.relationForKey("friendsRelation")

        friendsData.append(user)
        relation.addObject(user)
        allNonFriendUsers = allNonFriendUsers.filter({ $0 != user })

        let alertController = UIAlertController(title: nil, message: "\(user.name) is now a friend", preferredStyle: .Alert)
        let addFriendAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in
                
        self.filteredUsers = self.filteredUsers.filter({ $0 != user })
        self.friendsTableView.reloadData()
                
        })
            
        alertController.addAction(addFriendAction)
        self.presentViewController(alertController, animated: true, completion: nil)

        }
        PFUser.currentUser()!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
        if error != nil {
            
            self.displayAlert("Failed To Add Friend", message: "Please try again.", actionTitle: "OK")
            
            }
        })
    }
    
    func loadUserData() {
    allNonFriendUsers.removeAll()
        
    if let friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation {
    let friendQuery = friendsRelation.query()
    if let userQuery = PFUser.query() {
    userQuery.whereKey("username", doesNotMatchKey: "username", inQuery: friendQuery!)
    userQuery.findObjectsInBackgroundWithBlock({ (nonFriendUsers: [PFObject]?, error: NSError?) -> Void in
        if error == nil {
        for object:PFObject in nonFriendUsers! {
        if let nonFriendUser = object as? GolferProfile {
        self.allNonFriendUsers.append(nonFriendUser)
        for user in self.allNonFriendUsers {
        if user.objectId == PFUser.currentUser()?.objectId {
        self.allNonFriendUsers = self.allNonFriendUsers.filter({$0 != user})
                            
                            }
                        }
                    }
                }
            }
        })
    }
  }
}

    func loadFriendsData() {
        activityIndicator.startAnimating()
        friendsData.removeAll()
        
        if let friendsRelation = PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation {
        if let userQuery = friendsRelation.query() {
            userQuery.orderByAscending("username")
            userQuery.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                self.activityIndicator.stopAnimating()
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

    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find Friends"
        searchController.searchBar.barTintColor = UIColor(red: 255, green: 116.0/255.0, blue: 0, alpha: 1.0)
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        friendsTableView.tableHeaderView = searchController.searchBar
        
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the allUsers array and get only those users' username that match the search text.
        
        filteredUsers = allNonFriendUsers.filter({(user) -> Bool in
            let nameText: NSString = user.name
            
            return (nameText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            
        })
            
        friendsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        friendsTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        friendsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if shouldShowSearchResults {
            shouldShowSearchResults = true
            friendsTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }

        
}
