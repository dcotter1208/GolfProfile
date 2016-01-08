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
    var courseFromRealm = PreviousCourse()
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
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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

        if searchController.active {
        let searchCell = self.tableView.dequeueReusableCellWithIdentifier("courseSearchCell") as! SearchCourseCell
        let course = searchResults![indexPath.row]
        
        searchCell.searchCourseLabel.text = course.name
        searchCell.searchCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
            
        return searchCell
            
        } else {
        let previousCourseCell = self.tableView.dequeueReusableCellWithIdentifier("previousCourseCell") as! PreviousCourseCell
        let course = previousCoursesFromRealm[indexPath.row]
            
        previousCourseCell.previousCourseLabel.text = course.name
            
        if course.city == "" && course.state == "" {
                
        previousCourseCell.previousCourseLocationLabel.text = ""
                
            } else {
            
        previousCourseCell.previousCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
                
            }
            
        return previousCourseCell
            
        }
    
    }

}

extension CourseSearchTVC {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showNewScoreVC"  {
            
            let newScoreVC = segue.destinationViewController as! NewScoreViewController
            
            let selectedIndex = coursesTableView.indexPathForCell(sender as! UITableViewCell)
            
            newScoreVC.selectedCourse = previousCoursesFromRealm[selectedIndex!.row]
            
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
                
                addPreviousCourse.name = searchResults![indexPath.row].name
                addPreviousCourse.city = searchResults![indexPath.row].city
                addPreviousCourse.state = searchResults![indexPath.row].state
                
                self.previousCourse = addPreviousCourse

                if previousCoursesFromRealm.contains( { $0.name == previousCourse.name }) {
   
                displayAlert("Whoops!", message: "\(previousCourse.name) already exists inside of your previous course list. Please choose a different course.", actionTitle: "OK")
                    
                } else {
                    
                    realm.add(previousCourse)
                    searchController.active = false

                    }
                }
            
                if searchController.active == false {
                    
                    coursesTableView.reloadData()

                }
            }
        }
    }


extension CourseSearchTVC {
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !searchController.active
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {


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

