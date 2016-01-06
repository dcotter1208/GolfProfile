//
//  PrivacyPolicyVC.swift
//  GolfProfile
//
//  Created by Donovan Cotter on 1/6/16.
//  Copyright © 2016 DonovanCotter. All rights reserved.
//

import UIKit

class PrivacyPolicyVC: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        
        let url = NSURL (string: "https://www.iubenda.com/privacy-policy/7772504")
        let requestObj = NSURLRequest(URL: url!)
        webView.loadRequest(requestObj)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {

        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        activityIndicator.stopAnimating()
//        activityIndicator.hidden = true
        
    }
    
    
    @IBAction func dismissView(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
