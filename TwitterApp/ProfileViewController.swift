//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/28/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]! = []

    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designButton()
        setUpProfile()
        reloadTimeline()
        tableView.dataSource = self
        tableView.delegate = self
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpProfile() {
        nameLabel.text = User.currentUser!.name as? String
        usernameLabel.text = "@" + (User.currentUser!.screename as? String)!
        profileImageView.af_setImageWithURL((User.currentUser!.profileUrl)!)
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        bioLabel.text = User.currentUser!.userDescription as? String
        followingLabel.text = String((User.currentUser!.following)!)
        followersLabel.text = String((User.currentUser!.followers)!)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
        let tweet = self.tweets![indexPath.row]
        cell.tweet = tweet
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func reloadTimeline() {
        TwitterClient.sharedInstance.userTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            for tweet in tweets {
                print(tweet.text)
                self.tableView.reloadData()
            }
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    //    func reloadBanner() {
//        TwitterClient.sharedInstance.getBanner({ (user: User) -> () in
//            let userdictionary = User.currentUser!
//            
//            
//        }) { (error: NSError) -> () in
//                print(error.localizedDescription)
//        }
//    }
    func designButton() {
        logoutButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Medium", size: 12)
        logoutButton.backgroundColor = UIColor.clearColor()
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.borderWidth = 0.5
        logoutButton.layer.borderColor = UIColor.colorFromHex("#666666").CGColor
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        reloadTimeline()
        refreshControl.endRefreshing()
    }
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()    }
    
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets![(indexPath?.row)!]
        let detailViewController = segue.destinationViewController as! TweetDetailsViewController
        detailViewController.tweet = tweet
        print("prepare for segue has been called")
    }
 

}

extension UIColor {
    static func colorFromHex(hexString: String, alpha: CGFloat = 1) -> UIColor {
        //checking if hex has 7 characters or not including '#'
        if hexString.characters.count < 7 {
            return UIColor.whiteColor()
        }
        //string by removing hash
        let hexStringWithoutHash = hexString.substringFromIndex(hexString.startIndex.advancedBy(1))
        
        //I am extracting three parts of hex color Red (first 2 characters), Green (middle 2 characters), Blue (last two characters)
        let eachColor = [
            hexStringWithoutHash.substringWithRange(hexStringWithoutHash.startIndex...hexStringWithoutHash.startIndex.advancedBy(1)),
            hexStringWithoutHash.substringWithRange(hexStringWithoutHash.startIndex.advancedBy(2)...hexStringWithoutHash.startIndex.advancedBy(3)),
            hexStringWithoutHash.substringWithRange(hexStringWithoutHash.startIndex.advancedBy(4)...hexStringWithoutHash.startIndex.advancedBy(5))]
        
        let hexForEach = eachColor.map {CGFloat(Int($0, radix: 16) ?? 0)} //radix is base of numeric system you want to convert to, Hexadecimal has base 16
        
        //return the color by making color
        return UIColor(red: hexForEach[0] / 255, green: hexForEach[1] / 255, blue: hexForEach[2] / 255, alpha: alpha)
    }
}