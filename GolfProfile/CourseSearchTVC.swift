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
    var searchController: UISearchController!
    
    let config = Realm.Configuration(
        path: NSBundle.mainBundle().pathForResource("courseDataBase", ofType:"realm"),
        readOnly: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm(configuration: config)

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
        let realm = try! Realm(configuration: config)
        let searchResults = realm.objects(Course)
        print(searchResults)
        searchResults.filter(predicate).sorted("name", ascending: true)

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
        let realm = try! Realm(configuration: config)
        let searchResults = realm.objects(Course)
        
        return searchController.active ? searchResults.count : previousCourses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let realm = try! Realm(configuration: config)
        let searchResults = realm.objects(Course)
        let cell = self.tableView.dequeueReusableCellWithIdentifier("courseSearchCell") as! SearchCourseCell

        if searchController.active {
        let course = searchResults[indexPath.row]
        
        cell.searchCourseLabel.text = course.name
        cell.searchCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
            
        return cell
            
        } else {
            
        let course = previousCourses[indexPath.row]
            
        cell.searchCourseLabel.text = course.courseName
        cell.searchCourseLocationLabel.text = "\(course.city)" + "," + " " + "\(course.state)"
            
        return cell
            
        }
        
        
    }

}

//extension CourseSearchTVC {
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//
//        var courseInPreviousCourses = GolfCourse()
//        
//        if searchController.active {
//            
//            let realm = try! Realm(configuration: config)
//            let searchResults = realm.objects(Course)
//            
//            let golfCourse = searchResults[indexPath.row]
//            
//            let previousCourse = PFObject(className: "PreviousCourse")
//            
//            for course in previousCourses {
//            
//            courseInPreviousCourses = course
//                
//            }
//            
//            if courseInPreviousCourses.courseName == golfCourse.name {
//            
//                print("ALREADY A PREVIOUS COURSE")
//            
//            }
//        
//        }
//        
//        
//    }
//
//
//}

//extension CourseSearchTVC {
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        var courseInPreviousCourses = GolfCourse()
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        if searchController.active {
//            
//            let golfCourse = self.searchResults[indexPath.row]
//            
//            let previousCourse = PFObject(className:"PreviousCourse")
//            
//            for course in previousCourses {
//                
//                courseInPreviousCourses = course
//                
//            }
//            
//            if courseInPreviousCourses.courseName == golfCourse.name {
//                
//                print("ALREADY A PREVIOUS COURSE")
//                print(golfCourse.name)
//            } else {
//                let course:GolfCourse = golfCourse
//                previousCourses.append(golfCourse as GolfCourse)
//                previousCourse["courseName"] = golfCourse.name
//                previousCourse["city"] = golfCourse.city
//                previousCourse["state"] = golfCourse.state
//                previousCourse["golfer"] = PFUser.currentUser()
//                previousCourse.saveInBackgroundWithBlock {
//                    (success: Bool, error: NSError?) -> Void in
//                    if (success) {
//                        
//                    } else {
//                        print(error)
//                    }
//                }
//                
//            }
//            
//        }
//    }
//
//
//}
