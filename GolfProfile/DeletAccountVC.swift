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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func deleteAccount(sender: AnyObject) {
        
    let alertController1 = UIAlertController(title: "Last chance!", message: "Confirm PeerGolfer account deletion by selecting 'Delete'", preferredStyle: .Alert)
    let cancelDeletion = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
    let deleteAccountAction = UIAlertAction(title: "Delete", style: .Default) { (UIAlertAction) -> Void in
        
    PFUser.currentUser()?.deleteInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
            
        if success {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login")
            self.presentViewController(viewController, animated: true, completion: nil)
                
                })
                
            } else {
                
                print(error)
            
            }
        })

    }
        
        alertController1.addAction(cancelDeletion)
        alertController1.addAction(deleteAccountAction)
        self.presentViewController(alertController1, animated: true, completion: nil)
        
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }

}
