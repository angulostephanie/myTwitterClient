//
//  TweetDetailsViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/29/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    var tweet = Tweet?()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        importData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.navigationController!.navigationBar.tintColor = UIColor.colorFromHex("#FFCC00")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onProfileImage(sender: AnyObject) {
      performSegueWithIdentifier("OtherProfileSegue", sender: nil)
    }
    func importData() {
        tweetBodyLabel.text = tweet!.text!
        nameLabel.text = tweet!.user?.name as? String
        usernameLabel.text = "@" + (tweet!.user?.screename as? String)!
        profileImageView.af_setImageWithURL((tweet!.user?.profileUrl)!)
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        timestampLabel.text = tweet!.formattedTimeStampString!
        retweetLabel.text = String(tweet!.retweetCount)
        favoriteLabel.text = String(tweet!.favoriteCount)
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
