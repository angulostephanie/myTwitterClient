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
    @IBOutlet weak var profileImageButton: UIButton!
    
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
            
           if hasBeenRetweeted {
                retweetButton.setImage(UIImage(named: "greenretweet.png"), forState: UIControlState.Normal)
           } else {
                retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
            }
           
            if hasBeenFavorited {
                favoriteButton.setImage(UIImage(named: "red_heart.png"), forState: UIControlState.Normal)
            } else {
                favoriteButton.setImage(UIImage(named: "grayheart.png"), forState: UIControlState.Normal)
            }
        }
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        print("clicked retweet button")
        
        if hasBeenRetweeted {
            let newCount  = (Int(self.retweetLabel.text!))! - 1
            if tweet.retweetCount == 0 {
                retweetLabel.text = "0"
            } else {
                self.retweetLabel.text = String(newCount)
            }
            TwitterClient.sharedInstance.unretweet(myTweetIdStr, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "retweet-action.png"), forState: .Normal)
                print("unretweeted")
                
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
            self.hasBeenRetweeted = false
        } else {
            let newCount  = (Int(self.retweetLabel.text!))! + 1
            if tweet.retweetCount == 0 {
                retweetLabel.text = "0"
            } else {
                self.retweetLabel.text = String(newCount)
            }
            TwitterClient.sharedInstance.retweet(myTweetIdStr, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "greenretweet.png"), forState: .Normal)
                print("retweeted")
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
            self.hasBeenRetweeted = true
        }
    }
    
   @IBAction func onFavorite(sender: UIButton) {
        print("clicked favorite button")
        print("/1.1/favorites/create.json?id=\(myTweetIdStr)")
        if hasBeenFavorited {
            let newfavCount  = (Int(self.favoriteLabel.text!))! - 1
            if tweet.favoriteCount == 0 {
                favoriteLabel.text = "0"
            } else {
                self.favoriteLabel.text = String(newfavCount)
            }
            TwitterClient.sharedInstance.unfavorite(myTweetIdStr, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "grayheart.png"), forState: .Normal)
                print("not favorited")
                self.favoriteLabel.text = String(tweet.favoriteCount)
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
            self.hasBeenRetweeted = false
        } else {
            let newfavCount  = (Int(self.favoriteLabel.text!))! + 1
            self.favoriteLabel.text = String(newfavCount)
            TwitterClient.sharedInstance.favorite(myTweetIdStr, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "red_heart.png"), forState: .Normal)
                print("favorited <3")
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
            self.hasBeenRetweeted = true
        }
    
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
