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

class EditFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addFriendsTableView: UITableView!
        
    var allUsers = [GolferProfile]()
    var filteredUsers = [GolferProfile]()
    var friendsData = [GolferProfile]()
    var friendsRelation = PFRelation()
    let currentUser = PFUser.currentUser()
    var checkMarkArray = [Int]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsData()
        loadUserData()
        configureSearchController()
        addFriendsTableView.reloadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        addFriendsTableView.reloadData()
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
            
        print("FILTERED: \(filteredUsers.count)")
            
        let findFriendCell: FindFriendCell = tableView.dequeueReusableCellWithIdentifier("findFriendsCell", forIndexPath: indexPath) as! FindFriendCell
        findFriendCell.tintColor = UIColor.whiteColor()
        findFriendCell.findUsernameCellLabel.text = filteredUsers[indexPath.row].username
            
        findFriendCell.findFriendProfileCellImage.file = filteredUsers[indexPath.row].profileImage
        findFriendCell.findFriendProfileCellImage.loadInBackground()
        findFriendCell.findFriendProfileCellImage.layer.cornerRadius = findFriendCell.findFriendProfileCellImage.frame.size.width / 2
        
        for friend in filteredUsers {
            
        if isFriend(friend) {
        findFriendCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        checkMarkArray.append(indexPath.row)
            
        } else {
            
        findFriendCell.accessoryType = UITableViewCellAccessoryType.None
                        
         }
    
        }

         return findFriendCell
            
        } else {
        
        let friendCell:FriendsCell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath) as! FriendsCell
        friendCell.tintColor = UIColor.whiteColor()
            
        friendCell.friendUserNameCellLabel.text = friendsData[indexPath.row].username
        friendCell.friendProfileCell.file = friendsData[indexPath.row].profileImage
        friendCell.friendProfileCell.loadInBackground()
        friendCell.friendProfileCell.layer.cornerRadius = friendCell.friendProfileCell.frame.size.width / 2
        
        return friendCell
            
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFriendScores"  {
            
            let friendScoresVC = segue.destinationViewController as! FriendScoresViewController
            
            let selectedIndex = addFriendsTableView.indexPathForCell(sender as! UITableViewCell)
            
            
            
            
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if shouldShowSearchResults {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let user = self.filteredUsers[indexPath.row]
        
        let relation: PFRelation = PFUser.currentUser()!.relationForKey("friendsRelation")
            
        friendsRelation = PFUser.currentUser()!.relationForKey("friendsRelation")
        
        if isFriend(user) {
            cell?.accessoryType = UITableViewCellAccessoryType.None

            for friend in friendsData{
                if friend.objectId == user.objectId {
                relation.removeObject(friend)
                print("\(friend.username) REMOVED")
                    
         //filter through the original showFriends array and remove that selected "friend" from the array.
            friendsData = friendsData.filter({ $0 != friend })

                }
            }
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            friendsData.append(user)
            relation.addObject(user)
            print("\(user.username) ADDED")

        }
            PFUser.currentUser()!.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                }
            })
    
    }
        
}
        
    
    //Function that loads all of my PFUsers
    func loadUserData() {
        allUsers.removeAll()
        
        if let userQuery = PFUser.query() {
        userQuery.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        userQuery.findObjectsInBackgroundWithBlock { (users: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                
                for object:PFObject in users! {
                    if let user = object as? GolferProfile {
                            self.allUsers.append(user)
                            self.addFriendsTableView.reloadData()
                        }
                    }
                }
        
            }

        }
        
    }
    
    func loadFriendsData() {
        friendsData.removeAll()
        friendsRelation = (PFUser.currentUser()?.objectForKey("friendsRelation") as? PFRelation)!
        if let userQuery = friendsRelation.query() {
            userQuery.orderByAscending("username")
            userQuery.findObjectsInBackgroundWithBlock { (friends: [PFObject]?, error: NSError?) -> Void in
                if friends != nil {
                    
                    for object:PFObject in friends! {
                        if let object = object as? GolferProfile {
                            self.friendsData.append(object)
                            print(self.friendsData.count)
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.addFriendsTableView.reloadData()
                    }
                }
            }
        }
    }
    
        //Function to check if a user is a or isn't a current friend. If they are then we are using this method to display a checkmark by their name in our editFriendsVC
    func isFriend(user: PFUser) -> Bool {
        for friend in friendsData {
            if friend.objectId == user.objectId {
                return true
            }
            
        }
        
        return false
        
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        addFriendsTableView.tableHeaderView = searchController.searchBar
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the allUsers array and get only those users' username that match the search text.
        filteredUsers = allUsers.filter({(user) -> Bool in
            let nameText: NSString = user.username!
            
            return (nameText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        addFriendsTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        addFriendsTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        addFriendsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            addFriendsTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    
    
}
