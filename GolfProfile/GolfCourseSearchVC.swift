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
            
            searchCourseCell.golfCourseName.text = searchedGolfCourse[indexPath.row].name
            
            return searchCourseCell
            
        } else {
            
            let previousCourseCell:PreviousCourseCell = tableView.dequeueReusableCellWithIdentifier("previousCourseCell", forIndexPath: indexPath) as! PreviousCourseCell
            
            previousCourseCell.previousGolfCourseName.text = previousCourses[indexPath.row].name

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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if shouldShowSearchResults {
            
            let golfCourse = self.searchedGolfCourse[indexPath.row]
            
            
            previousCourses.append(golfCourse)
            let previousCourse = PFObject(className:"PreviousCourse")
            previousCourse["courseName"] = golfCourse.name
            previousCourse["golfer"] = PFUser.currentUser()
            previousCourse.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
            
                } else {
                    let alertController = UIAlertController(title: "No Network Connection", message: "Can't save score without a connection. Please try again later.", preferredStyle: .Alert)
            
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                }
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true) {
                }
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
        let searchString = searchController.searchBar.text
        
        // Filter the allUsers array and get only those users' username that match the search text.
        searchedGolfCourse = golfCourseCollection.filter({(course) -> Bool in
            let nameText: NSString = course.name
            
            return (nameText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        previousCourseListTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        previousCourseListTableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        previousCourseListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            previousCourseListTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    

    func loadCoursesFromJSONFile() {
        DataManager.getGolfCoursesFromFileWithSuccess { (data) -> Void in
            let json = JSON(data: data)
            
            if let courseArray = json.array {
                
                for course in courseArray {
                    
                    let courseName: String? = course["biz_name"].string

                    if courseName != nil {
                        let golfCourse = GolfCourse(name: courseName!)
                        self.golfCourseCollection.append(golfCourse)
                        print(self.golfCourseCollection.count)
                        
                    }
                }
                
            }
            
        }
    
    }
    

}
