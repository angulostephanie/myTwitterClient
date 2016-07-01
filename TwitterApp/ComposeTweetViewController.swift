//
//  ComposeTweetViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/30/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    
    var finishedTweet: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.becomeFirstResponder()
        profileImageView.af_setImageWithURL((User.currentUser!.profileUrl)!)
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        myTextView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidChange(textView: UITextView) {
        finishedTweet = myTextView.text
    }
//    TwitterClient.sharedInstance.retweet(myTweetIdStr, success: { (tweet) in
//    self.tweet = tweet
//    sender.setImage(UIImage(named: "greenretweet.png"), forState: .Normal)
//    print("retweeted")
//    
//    self.hasBeenRetweeted = true
//    }, failure: { (error:NSError) in
//    print(error.localizedDescription)
//    })

    @IBAction func onTweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.compose(myTextView.text, success: { () in
            print("YES")
        }, failure: { (error: NSError) in
            print("error")
        })
        self.performSegueWithIdentifier("newTweetSegue", sender: nil)
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
