//
//  CourseSearchTVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/29/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import RealmSwift

class CourseSearchTVC: UITableViewController {
    
    @IBOutlet var coursesTableView: UITableView!

    var courses = try! Realm().objects(Course).sorted("name", ascending: true)
    var searchResults = try! Realm().objects(Course)
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        
        print(try! Realm().objects(Course))

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureSearchBar() {
    let searchResultsController = UITableViewController(style: .Plain)
    searchResultsController.tableView.delegate = self
    searchResultsController.tableView.dataSource = self
    searchResultsController.tableView.rowHeight = 63
    searchResultsController.tableView.registerClass(SearchCourseCell.self, forCellReuseIdentifier: "courseSearchCell")
        
    searchController = UISearchController(searchResultsController: searchResultsController)
    searchController.searchResultsUpdater = self
    searchController.searchBar.sizeToFit()
    searchController.searchBar.tintColor = UIColor.blackColor()
    searchController.searchBar.delegate = self
    searchController.searchBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        coursesTableView.tableHeaderView = searchController.searchBar
        
    definesPresentationContext = true

    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        coursesTableView.tableHeaderView = searchController.searchBar
    }
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString) // 1
        let realm = try! Realm()
        
        searchResults = realm.objects(Course).filter(predicate).sorted("name", ascending: true)
        

    }
    
}

// MARK: - UISearchResultsUpdating
extension CourseSearchTVC: UISearchResultsUpdating {
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        filterResultsWithSearchString(searchString)
        
        let searchResultsController = searchController.searchResultsController as! UITableViewController
        searchResultsController.tableView.reloadData()
    }
    
}

// MARK: - UISearchBarDelegate
extension CourseSearchTVC:  UISearchBarDelegate {
    
}

// MARK: - UITableViewDataSource
extension CourseSearchTVC {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? searchResults.count : courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("courseSearchCell") as! SearchCourseCell
        
        let course = searchController.active ? searchResults[indexPath.row] : courses[indexPath.row]
        
        cell.searchCourseLabel.text = course.name
        cell.searchCourseLocationLabel.text = "(\(course.city)"
        
        return cell
    }
    
    
}
