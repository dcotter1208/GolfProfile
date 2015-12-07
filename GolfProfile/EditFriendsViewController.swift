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
        configureSearchController()
        loadUserData()
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
        
        let cell:EditFriendCell = tableView.dequeueReusableCellWithIdentifier("editFriendCell", forIndexPath: indexPath) as! EditFriendCell
        cell.tintColor = UIColor.whiteColor()
        
        if shouldShowSearchResults {
            
        cell.userNameCellLabel.text = filteredUsers[indexPath.row].username
            
        cell.editFriendProfileCellImage.file = filteredUsers[indexPath.row].profileImage
        cell.editFriendProfileCellImage.loadInBackground()
        cell.editFriendProfileCellImage.layer.cornerRadius = cell.editFriendProfileCellImage.frame.size.width / 2
        
        for friend in filteredUsers {
            
        if isFriend(friend) {
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        checkMarkArray.append(indexPath.row)
            
        } else {
            
        cell.accessoryType = UITableViewCellAccessoryType.None
                        
         }
    
        }
            
        } else {
        
        cell.userNameCellLabel.text = friendsData[indexPath.row].username
        cell.editFriendProfileCellImage.file = friendsData[indexPath.row].profileImage
        cell.editFriendProfileCellImage.loadInBackground()
        cell.editFriendProfileCellImage.layer.cornerRadius = cell.editFriendProfileCellImage.frame.size.width / 2
        
        }
            
        
//        //if the user is a friend then their name will have a checkmark
//        if isFriend(userInfo as! PFUser) {
//           cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//           checkMarkArray.append(indexPath.row)
//     
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryType.None
//            
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if shouldShowSearchResults {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let userInfo = self.filteredUsers[indexPath.row]
        
        friendsRelation = (PFUser.currentUser()?.relationForKey("friendsRelation"))!
        
        if isFriend(userInfo) {
            cell?.accessoryType = UITableViewCellAccessoryType.None

            for friend in friendsData{
                if friend.objectId == userInfo.objectId {
                friendsRelation.removeObject(friend)
                print("\(friend.username) REMOVED")
                    
         //filter through the original showFriends array and remove that selected "friend" from the array.
            friendsData = friendsData.filter({ $0 != friend })

                }
            }
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            friendsData.append(userInfo)
            friendsRelation.addObject(userInfo)
            print("\(userInfo.username) ADDED")

        }
        
        currentUser?.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
            } else {
                print(error)
            }
        }
    
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
