//
//  GolfCourseSearchVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 12/11/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class GolfCourseSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    var golfCourseCollection = [GolfCourse]()
    var searchedGolfCourse = [GolfCourse]()
    var previousCourses = [GolfCourse]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!

    @IBOutlet weak var previousCourseListTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        loadCoursesFromJSONFile()
        
        configureSearchController()
        
        print(previousCourses)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        
        loadUserPreviousCourses()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            
        return searchedGolfCourse.count
        
        } else {
            
        return previousCourses.count
            
        }

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if shouldShowSearchResults {
            let searchCourseCell:SearchCourseCell = tableView.dequeueReusableCellWithIdentifier("searchCourseCell", forIndexPath: indexPath) as! SearchCourseCell
            
            searchCourseCell.searchCourseLabel.text = searchedGolfCourse[indexPath.row].courseName
            searchCourseCell.searchCourseLocationLabel.text = searchedGolfCourse[indexPath.row].city + "," + " " + searchedGolfCourse[indexPath.row].state
            
            return searchCourseCell
            
        } else {
            
            let previousCourseCell:PreviousCourseCell = tableView.dequeueReusableCellWithIdentifier("previousCourseCell", forIndexPath: indexPath) as! PreviousCourseCell
            
            previousCourseCell.previousCourseLabel.text = previousCourses[indexPath.row].courseName
            previousCourseCell.previousCourseCityLabel.text = previousCourses[indexPath.row].city + "," + " " + previousCourses[indexPath.row].state
            
            return previousCourseCell
            
    }
    
}


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "showNewScoreVC"  {
        
        let newScoreVC = segue.destinationViewController as! NewScoreViewController
        
        let selectedIndex = previousCourseListTableView.indexPathForCell(sender as! UITableViewCell)
        
        newScoreVC.selectedCourse = previousCourses[selectedIndex!.row]
        
    }
}

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var courseInPreviousCourses = GolfCourse()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if shouldShowSearchResults {
            
            let golfCourse = self.searchedGolfCourse[indexPath.row]
            
            let previousCourse = PFObject(className:"PreviousCourse")
            
            for course in previousCourses {
                
                courseInPreviousCourses = course
            
            }
            
            if courseInPreviousCourses.courseName == golfCourse.courseName {
                print("ALREADY A PREVIOUS COURSE")
            } else {
                previousCourses.append(golfCourse)
                previousCourse["courseName"] = golfCourse.courseName
                previousCourse["city"] = golfCourse.city
                previousCourse["state"] = golfCourse.state
                previousCourse["golfer"] = PFUser.currentUser()
                previousCourse.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        
                    } else {
                        print(error)
                    }
                }

            }
            
        }
    }
    
    
    func loadCoursesFromJSONFile() {
        DataManager.getGolfCoursesFromFileWithSuccess { (data) -> Void in
            let json = JSON(data: data)
            
            if let courseArray = json.array {
                
                for course in courseArray {
                    
                    let golfCourseName: String? = course["biz_name"].string
                    let city: String? = course["e_city"].string
                    let state: String? = course["e_state"].string

                    if golfCourseName != nil {
                        let golfCourse = GolfCourse(className: "PreviousCourse")
                        golfCourse.courseName = golfCourseName!
                        golfCourse.city = city!
                        golfCourse.state = state!
                        self.golfCourseCollection.append(golfCourse)
                    }
                }
            }
            
        }
    
    }
    
    func loadUserPreviousCourses() {
        previousCourses.removeAll()
        if let query = GolfCourse.query() {
            query.whereKey("golfer", equalTo: PFUser.currentUser()!)
            
            query.findObjectsInBackgroundWithBlock { (previousCourses: [PFObject]?, error: NSError?) -> Void in
                if error == nil {

                    for object:PFObject in previousCourses! {
                        if let object = object as? GolfCourse {
                            self.previousCourses.append(object)
                            
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.previousCourseListTableView.reloadData()
                        
                    }
                    
                } else {
                    print(error)
                }
            }
        }
        
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
        
        previousCourseListTableView.tableHeaderView = searchController.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
//        if searchController.searchBar.text? >= 3 {
        
        let searchString = searchController.searchBar.text
//        }
        
        // Filter the allUsers array and get only those users' username that match the search text.
        searchedGolfCourse = golfCourseCollection.filter({(course) -> Bool in
            let nameText: NSString = course.courseName
            
            return (nameText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        dispatch_async(dispatch_get_main_queue()) {

        self.previousCourseListTableView.reloadData()
    
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        previousCourseListTableView.reloadData()
    }

    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        previousCourseListTableView.reloadData()
    }
//    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            previousCourseListTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    

}
