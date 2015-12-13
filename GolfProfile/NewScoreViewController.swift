//
//  NewScoreViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class NewScoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var golfCourseName: UITextField!
    @IBOutlet weak var scorecardImage: UIImageView?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scoreTextField: UITextField!
    
    var locationManager:CLLocationManager?
    let distanceSpan:Double = 500
    
    var imagePicker = UIImagePickerController()
    let date = NSDate()
    var golfCourseCollection:[GolfCourse]?
    var courses = [GolfCourse]()
    var selectedCourse: GolfCourse?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(selectedCourse)

        golfCourseName.text = selectedCourse?.courseName
        
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.setValue(UIColor.blackColor(), forKeyPath: "textColor")
        scorecardImage?.layer.borderWidth = 5.0
        scorecardImage?.layer.borderColor = UIColor.blackColor().CGColor
        
        imagePicker.delegate = self

        
    }
    
    override func viewDidAppear(animated: Bool) {
        if locationManager == nil {
            locationManager = CLLocationManager()
            
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50 // Don't send location updates with a distance smaller than 50 meters between them
            locationManager!.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(sender: UIButton) {
        
            self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func saveScoreButton(sender: AnyObject) {

        let golfScore = PFObject(className:"GolfScorecard")
        golfScore["score"] = Int(scoreTextField.text!)
        golfScore["golfer"] = PFUser.currentUser()
        golfScore["golfCourse"] = golfCourseName.text!
        golfScore["date"] = datePicker.date
        
        if scorecardImage?.image == nil {
            
            scorecardImage?.image = UIImage(named: "noScorecard")
            
        } else {
            
            let pickedImage = self.scorecardImage?.image
            let scaledImage = self.scaleImageWith(pickedImage!, newSize: CGSizeMake(400, 400))
            let imageData = UIImagePNGRepresentation(scaledImage)
            let parseImageFile = PFFile(name: "scorecard.png", data: imageData!)
            golfScore["scorecardImage"] = parseImageFile
       
            
        }
        
        golfScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }

                
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
        
        let actionSheet = UIAlertController(title: "New Scorecard", message: "Take a photo or choose from your library", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraButton = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (ACTION) -> Void in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default, handler: { (ACTION) -> Void in
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (ACTION) -> Void in
            
        }
        
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(cancel)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

    

}
