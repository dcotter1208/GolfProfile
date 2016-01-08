//
//  NewScoreViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse
import RealmSwift
import ALCameraViewController

class NewScoreViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var golfCourseName: UITextField!
    @IBOutlet weak var scorecardImage: UIImageView?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scoreTextField: UITextField?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var previousCoursesFromRealm = try! Realm().objects(PreviousCourse).sorted("name", ascending: true)
    let croppingEnabled = true
    let libraryEnabled: Bool = true
    let date = NSDate()
    var userAddedCourse = PreviousCourse()
    var selectedCourse = PreviousCourse()

    override func viewDidLoad() {
        super.viewDidLoad()

        golfCourseName.text = selectedCourse.name
        scorecardImage?.layer.borderWidth = 5.0
        scorecardImage?.layer.borderColor = UIColor.blackColor().CGColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        
    self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func saveScoreButton(sender: UIBarButtonItem) {
        
        activityIndicator.startAnimating()
        saveButton.enabled = false
        let golfScorecard = PFObject(className: "GolfScorecard")
   
        if scoreTextField?.text?.characters.count == 0 {
            
        activityIndicator.stopAnimating()
        displayAlert("Invalid Score", message: "You didn't enter a score.", actionTitle: "OK")
        saveButton.enabled = true
            
        } else if scoreTextField?.text?.characters.count == 1 {
            
        activityIndicator.stopAnimating()
        displayAlert("Invalid Score", message: "No way you're good enough to have a score of \(scoreTextField!.text!)", actionTitle: "OK")
            saveButton.enabled = true
        
        } else if (scoreTextField?.text?.characters.count)! > 3 || Int(scoreTextField!.text!) >= 200  {
            
        activityIndicator.stopAnimating()
        displayAlert("Invalid Score", message: "You entered a score of \(scoreTextField!.text!). You can't be that bad!", actionTitle: "OK")
            saveButton.enabled = true
            
        } else if golfCourseName.text?.characters.count < 1 {
            
        activityIndicator.stopAnimating()
        displayAlert("Invalid Course", message: "Please enter a valid golf course", actionTitle: "OK")
        saveButton.enabled = true
        
        } else {
        
        golfScorecard["score"] = Int(scoreTextField!.text!)
        golfScorecard["golfer"] = PFUser.currentUser()
        golfScorecard["golfCourse"] = golfCourseName.text
        golfScorecard["date"] = datePicker.date
        if selectedCourse.city == "" && selectedCourse.state == "" {
        golfScorecard["courseLocation"] = ""
        } else {
        golfScorecard["courseLocation"] = "\(selectedCourse.city)" + "," + " " + "\(selectedCourse.state)"
        }
        
        if scorecardImage?.image != nil {
        
        let pickedImage = self.scorecardImage?.image
        if let imagePicked = pickedImage {
        let scaledImage = self.scaleImageWith(imagePicked, newSize: CGSizeMake(400, 400))
        let imageData = UIImagePNGRepresentation(scaledImage)
        let parseImageFile = PFFile(name: "scorecard.png", data: imageData!)
        golfScorecard["scorecardImage"] = parseImageFile

         }
    }
            
        let realm = try! Realm()
        try! realm.write {
        let addPreviousCourse = PreviousCourse()
                
        addPreviousCourse.name = golfCourseName.text!
        addPreviousCourse.city = ""
        addPreviousCourse.state = ""
                
        userAddedCourse = addPreviousCourse
        
        if previousCoursesFromRealm.contains( { $0.name == userAddedCourse.name }) {
                
        } else {
            
        realm.add(userAddedCourse)
            
            }
        }

        golfScorecard.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
        if (success) {
        self.activityIndicator.stopAnimating()
        self.saveButton.enabled = true
        dispatch_async(dispatch_get_main_queue()) {
            
        self.performSegueWithIdentifier("unwindFromNewScoreVCToProfileVC", sender: self)
            
        }
            
    } else {
            
        self.activityIndicator.stopAnimating()
        self.displayAlert("Save Failed", message: "Please check network connection or try again", actionTitle: "OK")
            
            }
        })
    }
}

    func scaleImageWith(image: UIImage, newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    @IBAction func addScorecardActionSheet(sender: AnyObject) {
        
        let cameraViewController = ALCameraViewController(croppingEnabled: croppingEnabled, allowsLibraryAccess: libraryEnabled) { (image) -> Void in
        self.scorecardImage!.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        
    }
    


}
