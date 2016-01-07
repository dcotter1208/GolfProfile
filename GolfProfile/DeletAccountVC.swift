//
//  DeletAccountVC.swift
//  PeerGolfer
//
//  Created by Donovan Cotter on 1/6/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class DeletAccountVC: UIViewController {
    @IBOutlet weak var deleteAccountTextView: UITextView!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextFieldOne: UITextField!
    @IBOutlet weak var passwordTextFieldTwo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWillLayoutSubviews()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func deleteAccount(sender: AnyObject) {

//if PFUser.currentUser()?.username == emailAddressTextField.text && PFUser.currentUser()?.password == passwordTextFieldOne.text && PFUser.currentUser()?.password == passwordTextFieldTwo.text {

    PFUser.currentUser()?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                
                if success {
                
                let alertController = UIAlertController(title: "Success!", message: "Now Please Login", preferredStyle: .Alert)
                    
                let enterAppAction = UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in
                        
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })

                })
                    
                    alertController.addAction(enterAppAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                } else {
                print(error)
                
        }

            })
            
//    }
    
        
        
    }
    
    
    override func viewWillLayoutSubviews() {
        
        deleteAccountTextView.layer.cornerRadius = 3.0
        deleteAccountTextView.layer.borderWidth = 3.0
        deleteAccountTextView.layer.borderColor = UIColor.blackColor().CGColor

    }
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


}
