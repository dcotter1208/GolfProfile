//
//  NewScoreViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class NewScoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var golfCourseName: UITextField!
    @IBOutlet weak var scorecardImage: UIImageView?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scorePicker: UIPickerView!
    
    var imagePicker = UIImagePickerController()
    let date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        
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
        golfScore["score"] = (scorePicker.selectedRowInComponent(0))
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
                print("NOT SAVED")
                
            }
        }
        
    }
    

    @IBAction func photoLibraryButton(sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func camButton(sender: UIButton) {
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
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

    
    //Mark: Picker Methods
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 200
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

}
