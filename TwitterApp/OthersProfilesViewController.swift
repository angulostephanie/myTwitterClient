//
//  OthersProfilesViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 7/1/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class OthersProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var user: User?
    var tweets: [Tweet]! = []

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpProfile()
        designButton()
        reloadTimeline()
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor();
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpProfile() {
        nameLabel.text = user!.name as? String
        usernameLabel.text = "@" + (user!.screename as? String)!
        profileImageView.af_setImageWithURL((user!.profileUrl)!)
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        bioLabel.text = user!.userDescription as? String
        followingLabel.text = String((user!.following)!)
        followerLabel.text = String((user!
            .followers)!)
    }
    func designButton() {
        logoutButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Medium", size: 12)
        logoutButton.backgroundColor = UIColor.clearColor()
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.borderWidth = 0.5
        logoutButton.layer.borderColor = UIColor.colorFromHex("#666666").CGColor
    }
    func reloadTimeline() {
        TwitterClient.sharedInstance.userTimeLine(usernameLabel.text, user_id: user!.id, success:
            { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                for tweet in tweets {
                    //print(tweet.text)
                    self.tableView.reloadData()
                }
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
        let tweet = self.tweets![indexPath.row]
        cell.tweet = tweet
        return cell
    }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return tweets?.count ?? 0
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
