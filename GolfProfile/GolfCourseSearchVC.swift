//
//  GolfCourseSearchVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/11/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit

class GolfCourseSearchVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var golfCourseListTableView: UITableView!
    
    var golfCourseCollection:[GolfCourse]?
    var searchedGolfCourse = [GolfCourse]()
    var courses = [GolfCourse]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCellWithIdentifier("golfCourseCell", forIndexPath: indexPath)
     
    return cell
        
    }
    
    // MARK: Search Controller
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find Courses"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        golfCourseListTableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        
        // Filter the allUsers array and get only those users' username that match the search text.
        searchedGolfCourse = golfCourseCollection!.filter({(course) -> Bool in
            let nameText: NSString = course.name
            
            return (nameText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        golfCourseListTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        golfCourseListTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        golfCourseListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            golfCourseListTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    

}
