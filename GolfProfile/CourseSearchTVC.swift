//
//  CourseSearchTVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/29/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import RealmSwift

class CourseSearchTVC: UITableViewController {
    
    @IBOutlet var coursesTableView: UITableView!

    var previousCourses = [GolfCourse]()
    var courses = try! Realm().objects(Course).sorted("name", ascending: true)
    var searchResults = try! Realm().objects(Course)
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserPreviousCourses()
        configureSearchBar()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadUserPreviousCourses() {
        previousCourses.removeAll()
        if let query = GolfCourse.query() {
            query.whereKey("golfer", equalTo: PFUser.currentUser()!)
            
            query.findObjectsInBackgroundWithBlock { (courses: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object:PFObject in courses! {
                        if let object = object as? GolfCourse {
                            self.previousCourses.append(object)
                            print(self.previousCourses)
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.coursesTableView.reloadData()
                    }
                    
                } else {
                    print(error)
                }
            }
        }
        
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
    searchController.searchBar.barTintColor = UIColor(red: 255, green: 116.0/255.0, blue: 0, alpha: 1.0)
        coursesTableView.tableHeaderView = searchController.searchBar
        
    definesPresentationContext = true

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
        return searchController.active ? searchResults.count : previousCourses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("courseSearchCell") as! SearchCourseCell

        if searchController.active {
        
        let course = searchResults[indexPath.row]
        
        cell.searchCourseLabel.text = course.name
        cell.searchCourseLocationLabel.text = "(\(course.city)"
            
        return cell
            
        } else {
            
        let course = previousCourses[indexPath.row]
            
        cell.searchCourseLabel.text = course.courseName
        cell.searchCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
            
        return cell
            
        }
        
        
    }
    
    
}
