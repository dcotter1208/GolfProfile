//
//  PrivacyPolicyVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 1/6/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL (string: "https://www.iubenda.com/privacy-policy/7772504")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
