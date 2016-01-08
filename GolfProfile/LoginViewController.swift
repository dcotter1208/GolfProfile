//
//  LoginViewController.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 11/2/15.
//  Copyright © 2015 DonovanCotter. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func login(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        PFUser.logInWithUsernameInBackground((self.usernameTextField.text?.lowercaseString)!, password: (self.passwordTextField.text)!) {
            (user: PFUser?, error: NSError?) -> Void in

            if error?.code == 101 {
            self.activityIndicator.stopAnimating()
            let alertController = UIAlertController(title: "Whoops!", message: "Username or password invalid. Please try again", preferredStyle: .Alert)
                
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
            self.presentViewController(alertController, animated: true, completion: nil)

            
            } else if error?.code == 100 {
                self.activityIndicator.stopAnimating()
                self.displayAlert("No Network Connection", message: "Please check connection", actionTitle: "OK")
            
            }
            
            if user != nil {
                self.activityIndicator.stopAnimating()
                dispatch_async(dispatch_get_main_queue()) {
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                self.presentViewController(viewController, animated: true, completion: nil)
                    
            }
        }
    }
        
}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func displayAlert(alterTitle: String?, message: String?, actionTitle: String?) {
        
        let alertController = UIAlertController(title: alterTitle, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: actionTitle, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    

}

