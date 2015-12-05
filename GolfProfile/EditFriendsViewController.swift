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
    var showFriends = [PFObject]()
    var friendsRelation = PFRelation()
    let currentUser = PFUser.currentUser()
    var checkMarkArray = [Int]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        return allUsers.count
            
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:EditFriendCell = tableView.dequeueReusableCellWithIdentifier("editFriendCell", forIndexPath: indexPath) as! EditFriendCell
        
        let userInfo:PFObject = self.allUsers[indexPath.row]
        
        if shouldShowSearchResults {
            
        cell.userNameCellLabel.text = filteredUsers[indexPath.row].username
            
        cell.editFriendProfileCellImage.file = filteredUsers[indexPath.row].profileImage
        cell.editFriendProfileCellImage.loadInBackground()
        cell.editFriendProfileCellImage.layer.cornerRadius = cell.editFriendProfileCellImage.frame.size.width / 2
            
        cell.tintColor = UIColor.whiteColor()
            
        } else {
            
        cell.userNameCellLabel.text = allUsers[indexPath.row].username
        
        cell.editFriendProfileCellImage.file = allUsers[indexPath.row].profileImage
        cell.editFriendProfileCellImage.loadInBackground()
        cell.editFriendProfileCellImage.layer.cornerRadius = cell.editFriendProfileCellImage.frame.size.width / 2
        
        }
            
        cell.tintColor = UIColor.whiteColor()
        
        //if the user is a friend then their name will have a checkmark
        if isFriend(userInfo as! PFUser) {
           cell.accessoryType = UITableViewCellAccessoryType.Checkmark
           checkMarkArray.append(indexPath.row)
     
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //*****THIS IS WHERE I NEED TO FIX MY ISSUE FOR SEARCH SELECTION****///
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let userInfo:PFObject = self.allUsers[indexPath.row]
        
        friendsRelation = (PFUser.currentUser()?.relationForKey("friendsRelation"))!
        
        if isFriend(userInfo as! PFUser) {
            cell?.accessoryType = UITableViewCellAccessoryType.None

            for friend in showFriends{
                if friend.objectId == userInfo.objectId {
                friendsRelation.removeObject(friend)
                    
         //filter through the original showFriends array and remove that selected "friend" from the array.
            showFriends = showFriends.filter({ $0 != friend })

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
                
            } else {
                print(error)
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
        //Function to check if a user is a or isn't a current friend. If they are then we are using this method to display a checkmark by their name in our editFriendsVC
    func isFriend(user: PFUser) -> Bool {
        for friend in showFriends {
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
