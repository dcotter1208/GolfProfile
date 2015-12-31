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
    var previousCoursesFromRealm = try! Realm().objects(PreviousCourse).sorted("name", ascending: true)
    var previousCourse = PreviousCourse()
    var searchController: UISearchController!
    
    var realmDataManager = RealmDataManager()
    var results = Results<(Course)>?()
    var searchResults = Results<(Course)>?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realmDataManager.configureRealmData()
        results = realmDataManager.results
        configureSearchBar()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        coursesTableView.reloadData()
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
    searchController.searchBar.barTintColor = UIColor(red: 255, green: 116.0/255.0, blue: 0, alpha: 1.0)
        coursesTableView.tableHeaderView = searchController.searchBar
        
    definesPresentationContext = true

    }
    
    func filterResultsWithSearchString(searchString: String) {
        let predicate = NSPredicate(format: "name BEGINSWITH [c]%@", searchString) // 1

        searchResults = results!.filter(predicate).sorted("name", ascending: true)
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
        
        return searchController.active ? searchResults!.count : previousCoursesFromRealm.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCellWithIdentifier("courseSearchCell") as! SearchCourseCell
        
        if searchController.active {
        
        let course = searchResults![indexPath.row]
        
        cell.searchCourseLabel.text = course.name
        cell.searchCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
            
        return cell
            
        } else {
            
        let course = previousCoursesFromRealm[indexPath.row]
            
        cell.searchCourseLabel.text = course.name
        cell.searchCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
            
        return cell
            
        }
    
        
    }

}

extension CourseSearchTVC {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if searchController.active {
            
        let realm = try! Realm()
            try! realm.write {
            let addPreviousCourse = PreviousCourse()
            
            if searchResults![indexPath.row].name != "" {
                
            addPreviousCourse.name = searchResults![indexPath.row].name
            addPreviousCourse.city = searchResults![indexPath.row].city
            addPreviousCourse.state = searchResults![indexPath.row].state
            
            self.previousCourse = addPreviousCourse
            realm.add(previousCourse)
            print(previousCourse)
            searchController.active = false
            
                if searchController.active == false {
                
                coursesTableView.reloadData()
                }
                }
            }

        } else {
            
            print(previousCoursesFromRealm[indexPath.row])
            
        
        }

    }
}

extension CourseSearchTVC {
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
        if searchController.active {
            
        UITableViewCellEditingStyle.None
            

        } else {
    
        

        let deletedValue = previousCoursesFromRealm[indexPath.row]
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let realm = try! Realm()
            try! realm.write {
                realm.delete(deletedValue)
            }
            
            coursesTableView.reloadData()
                }
            }
        }
    }

