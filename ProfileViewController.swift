//
//  ProfileViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var golferNameLabel: UILabel!
    @IBOutlet weak var golferProfileImage: PFImageView!
    @IBOutlet weak var userScoreTableView: UITableView!
    @IBOutlet weak var scoreViewSegmentedControl: UISegmentedControl!
    @IBOutlet var photoTapGesture: UITapGestureRecognizer!
    
    var profileData = [GolferProfile]()
    var userScorecardData = [GolfScorecard]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(profileData)
        
        if PFUser.currentUser() != nil {
            
            getProfileFromBackground()
            loadUserScorecardData()
            
        }

        self.userScoreTableView.addSubview(self.refreshControl)

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if PFUser.currentUser() == nil {
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return userScorecardData.count

    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:CurrentUserScorecardCell = tableView.dequeueReusableCellWithIdentifier("userScorecardCell", forIndexPath: indexPath) as! CurrentUserScorecardCell
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        cell.dateCellLabel?.text = dateFormatter.stringFromDate(userScorecardData[indexPath.row].date)
        
        cell.scoreCellLabel?.text = "\(userScorecardData[indexPath.row].score)"
        
        cell.golfCourseCellLabel?.text = userScorecardData[indexPath.row].golfCourse
        
        cell.scorecardCellImage.image = UIImage(named: "noScorecard")
        
        cell.scorecardCellImage.file = userScorecardData[indexPath.row].scorecardImage
        cell.scorecardCellImage.loadInBackground()
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let selectedScorecard:PFObject = userScorecardData[indexPath.row] as PFObject
            
            selectedScorecard.deleteInBackground()
            userScorecardData.removeAtIndex(indexPath.row)
            userScoreTableView.reloadData()
            
        }
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        
//    }
//    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        if segue.identifier == "showScorecardDetail" {
            
            let userScorecardDetailVC = segue.destinationViewController as? ProfilePhotoAndScorecardPhotoVC
            
            let selectedIndex = userScoreTableView.indexPathForCell(sender as! UITableViewCell)
            
            userScorecardDetailVC?.scorecard = userScorecardData[selectedIndex!.row]
            
        } else if segue.identifier == "showProfilePhoto" {
        
            let profilePhotoAndScorecardPhotoVC = segue.destinationViewController as? ProfilePhotoAndScorecardPhotoVC
            
            profilePhotoAndScorecardPhotoVC?.userProfileData = profileData

        }
        
    }

    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if let error = error {
                print(error)
            
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                    self.presentViewController(viewController, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func unwindToProfilePage(segue: UIStoryboardSegue) {
        
        getProfileFromBackground()
        
    }
    
    @IBAction func unwindFromNewScoreToProfilePage(segue: UIStoryboardSegue) {
        
        loadUserScorecardData()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.golferProfileImage.layer.cornerRadius = self.golferProfileImage.frame.size.width / 2
        self.golferProfileImage.layer.borderWidth = 3.0
        self.golferProfileImage.layer.borderColor = UIColor.orangeColor().CGColor
        self.golferProfileImage.clipsToBounds = true
        
    }
    
    func getProfileFromBackground() {
        profileData.removeAll()
        if let userQuery = PFUser.query() {
            userQuery.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
            userQuery.findObjectsInBackgroundWithBlock({ (currentUserProfile:[PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    for object:PFObject in currentUserProfile! {
                    if let object = object as? GolferProfile {
                    self.profileData.append(object)
                    for data in self.profileData {
                    dispatch_async(dispatch_get_main_queue()) {
                    self.golferNameLabel.text = data.name
                    self.golferProfileImage.file = data.profileImage
                    self.golferProfileImage.loadInBackground()
                            }
                        }
                    }
                }
                    
            } else {
            print(error)
                
            }
            })
        }
    }
    
    func loadUserScorecardData() {
        userScorecardData.removeAll()
        
        if let query = GolfScorecard.query() {
        if PFUser.currentUser() != nil {
        query.whereKey("golfer", equalTo: PFUser.currentUser()!)
        query.orderByDescending("date")
        
        query.findObjectsInBackgroundWithBlock { (scorecards: [PFObject]?, error: NSError?) -> Void in
        if error == nil {
            for object:PFObject in scorecards! {
            if let object = object as? GolfScorecard {
            self.userScorecardData.append(object)
                    }
                }
            dispatch_async(dispatch_get_main_queue()) {
                    
                self.userScoreTableView.reloadData()
                        
                    }
                
                } else {
                    print(error)
                }
            }
        }
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        loadUserScorecardData()
        self.userScoreTableView.reloadData()
        scoreViewSegmentedControl.selectedSegmentIndex = 0
        refreshControl.endRefreshing()
        
    }
    
    @IBAction func scoreViewSegmentedControlPushed(sender: AnyObject) {
        
        switch (scoreViewSegmentedControl.selectedSegmentIndex) {
        case 0:
            userScorecardData.sortInPlace({$0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
            userScoreTableView.reloadData()
            
        case 1:
            userScorecardData.sortInPlace({$0.score < $1.score})
            userScoreTableView.reloadData()
            
        case 2:
            userScorecardData.sortInPlace({$0.score > $1.score})
            userScoreTableView.reloadData()
            
        default:
            print("ERROR")
        }
        
    }
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }


    
}
