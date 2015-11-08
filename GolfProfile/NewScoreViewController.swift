//
//  NewScoreViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/3/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class NewScoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var golfCourseName: UITextField!
    @IBOutlet weak var gameScore: UITextField!
    @IBOutlet weak var gameDate: UITextField!
    @IBOutlet weak var scorecardImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveScoreButton(sender: AnyObject) {

        let golfScore = PFObject(className:"GolfScorecard")
        golfScore["score"] = gameScore.text!
        golfScore["playerName"] = PFUser.currentUser()
        golfScore["GolfCourse"] = golfCourseName.text!
        golfScore["date"] = gameDate.text!
        
        let pickedImage = self.scorecardImage.image
        let scaledImage = self.scaleImageWith(pickedImage!, newSize: CGSizeMake(400, 400))
        let imageData = UIImagePNGRepresentation(scaledImage)
        let parseImageFile = PFFile(name: "scorecard.png", data: imageData!)
        golfScore["scorecardImage"] = parseImageFile
        
        golfScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                
            } else {

                
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
        scorecardImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        scorecardImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    

    func scaleImageWith(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }


}
