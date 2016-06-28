//
//  LoginViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/27/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    let my_consumerKey: String! = "d6I5vFvGdL4IVAZRGb8xVwpeB"
    let my_consumerSecret: String! = "ajwNDdkMehiuXEi1FT5Hd6WtmJYFETu9pKIwUHXBZUqXp8opAF"
    let baseUrl: String! = "https://api.twitter.com"
    let requestUrl: String! = "/oauth/request_token"
    let authoUrl: String! = "/oauth/authorize"
    let accessUrl: String! = "/oauth/access_token"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.login({ () -> () in
            print("okiedokey i'm logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) in
                print("Error: \(error.localizedDescription)")
            //put error alert up
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
