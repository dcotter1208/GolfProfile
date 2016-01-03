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

class NewScoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var golfCourseName: UITextField!
    @IBOutlet weak var scorecardImage: UIImageView?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scoreTextField: UITextField?
    let croppingEnabled = true
    let libraryEnabled: Bool = true
    
    var imagePicker = UIImagePickerController()
    let date = NSDate()
    var selectedCourse = PreviousCourse()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedCourse)

        golfCourseName.text = selectedCourse.name
        
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
        scorecardImage?.layer.borderWidth = 5.0
        scorecardImage?.layer.borderColor = UIColor.blackColor().CGColor
        
        imagePicker.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        
    self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func saveScoreButton(sender: AnyObject) {
        
        let golfScorecard = PFObject(className: "GolfScorecard")
   
        if scoreTextField?.text?.characters.count == 0 {
         
        displayAlert("Invalid Score", message: "You didn't enter a score.", actionTitle: "OK")
            
        } else if scoreTextField?.text?.characters.count == 1 {
            
        displayAlert("Invalid Score", message: "No way you're good enough to have a score of \(scoreTextField!.text!)", actionTitle: "OK")
        
        } else if (scoreTextField?.text?.characters.count)! > 3 || Int(scoreTextField!.text!) >= 200  {
        
        displayAlert("Invalid Score", message: "You entered a score of \(scoreTextField!.text!). You can't be that bad!", actionTitle: "OK")
            
        } else {
        
        golfScorecard["score"] = Int(scoreTextField!.text!)
        golfScorecard["golfer"] = PFUser.currentUser()
        golfScorecard["golfCourse"] = golfCourseName.text
        golfScorecard["date"] = datePicker.date
        
        if scorecardImage?.image != nil {
        
        let pickedImage = self.scorecardImage?.image
        if let imagePicked = pickedImage {
        let scaledImage = self.scaleImageWith(imagePicked, newSize: CGSizeMake(400, 400))
        let imageData = UIImagePNGRepresentation(scaledImage)
        let parseImageFile = PFFile(name: "scorecard.png", data: imageData!)
        golfScorecard["scorecardImage"] = parseImageFile

         }
    }

        golfScorecard.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
        if (success) {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.performSegueWithIdentifier("segueToProfileView", sender: self)
            
        }
    } else {
        self.displayAlert("Save Failed", message: "Please check network connection or try again", actionTitle: "OK")
        }
    })
        }
}
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        scorecardImage?.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
