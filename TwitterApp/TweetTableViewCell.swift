//
//  TweetTableViewCell.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/28/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    var hasBeenRetweeted: Bool = false
    var hasBeenFavorited: Bool = false
    var myTweetIdStr : String?
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            tweetBodyLabel.text = tweet.text!
            nameLabel.text = tweet.user?.name as? String
            usernameLabel.text = "@" + (tweet.user?.screename as? String)!
            profileImageView.af_setImageWithURL((tweet.user?.profileUrl)!)
            timestampLabel.text = tweet.formattedTimeStampString!
            myTweetIdStr = tweet.tweetIDStr
            
            retweetLabel.text = String(tweet.retweetCount)
            
            favoriteLabel.text = String(tweet.favoriteCount)
            
        
            hasBeenRetweeted = tweet.retweetedByCurrentUser!
            hasBeenFavorited = tweet.favoritedByCurrentUser!
            
//            if hasBeenRetweeted {
//                retweetButton.setImage(UIImage(named: "greenretweet.png"), forState: UIControlState.Normal)
//            }
//            
//            if hasBeenFavorited {
//                favoriteButton.setImage(UIImage(named: "red_heart.png"), forState: UIControlState.Normal)
//            }
        }
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        print("clicked retweet button")
        
        //        if hasBeenRetweeted {
//            TwitterClient.sharedInstance.unretweet(tweet.tweetID!, success: { (tweet) in
//                    self.tweet = tweet
//                sender.setImage(UIImage(named: "retweet-action.png"), forState: .Normal)
//                print("unretweeted")
//                tweet.retweetCount -= 1
//                self.retweetLabel.text = String(tweet.retweetCount -= 1)
//                self.hasBeenRetweeted = false
//                }, failure: { (error:NSError) in
//                    print(error.localizedDescription)
//            })
//        } else {
        let newCount  = (Int(self.retweetLabel.text!))! + 1
        self.retweetLabel.text = String(newCount)
        TwitterClient.sharedInstance.retweet(myTweetIdStr, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "greenretweet.png"), forState: .Normal)
                print("retweeted")

                self.hasBeenRetweeted = true
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        
    }
    //}
    
   @IBAction func onFavorite(sender: UIButton) {
        print("clicked favorite button")
        print("/1.1/favorites/create.json?id=\(myTweetIdStr)")
    //        if !hasBeenFavorited {
//            TwitterClient.sharedInstance.unfavorite(tweet.tweetID!, success: { (tweet) in
//                self.tweet = tweet
//                sender.setImage(UIImage(named: "grayheart.png"), forState: .Normal)
//                print("not favorited")
//                self.favoriteLabel.text = String(tweet.favoriteCount)
//                }, failure: { (error:NSError) in
//                    print(error.localizedDescription)
//            })
//        } else {
        let newfavCount  = (Int(self.favoriteLabel.text!))! + 1
        self.favoriteLabel.text = String(newfavCount)
        TwitterClient.sharedInstance.favorite(myTweetIdStr, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "red_heart.png"), forState: .Normal)
                print("favorited <3")
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        }
    
    @IBAction func onProfileImage(tweet:Tweet?, sender: AnyObject) {
       //self.performSegueWithIdentifier("OtherProfileSegue", sender: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 4
        profileImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
