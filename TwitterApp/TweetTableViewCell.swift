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
    
    var retweetImage: UIImage?
    
    var tweet: Tweet! {
        didSet {
            tweetBodyLabel.text = tweet.text!
            nameLabel.text = tweet.user?.name as? String
            usernameLabel.text = tweet.user?.screename as? String
            profileImageView.af_setImageWithURL((tweet.user?.profileUrl)!)
            timestampLabel.text = tweet.formattedTimeStampString! 
            retweetLabel.text = String(tweet.retweetCount)
            favoriteLabel.text = String(tweet.favoriteCount)
        }
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        print("clicked retweet button")
        if tweet!.retweeted {
            TwitterClient.sharedInstance.unretweet(tweet.tweetID!, success: { (tweet) in
                    self.tweet = tweet
                sender.setImage(UIImage(named: "retweet-action.png"), forState: .Normal)
                print("unretweeted")
                self.retweetLabel.text = String(tweet.retweetCount)
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.retweet(tweet.tweetID!, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "greenretweet.png"), forState: .Normal)
                print("retweeted")
                self.retweetLabel.text = String(tweet.retweetCount)
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        }
    }
    
   @IBAction func onFavorite(sender: UIButton) {
        print("clicked favorite button")
        if tweet.favorited {
            TwitterClient.sharedInstance.unfavorite(tweet.tweetID!, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "grayheart.png"), forState: .Normal)
                print("not favorited")
                self.favoriteLabel.text = String(tweet.favoriteCount)
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.retweet(tweet.tweetID!, success: { (tweet) in
                self.tweet = tweet
                sender.setImage(UIImage(named: "red_heart.png"), forState: .Normal)
                self.favoriteLabel.text = String(tweet.favoriteCount + 1)
                print("favorited <3")
                }, failure: { (error:NSError) in
                    print(error.localizedDescription)
            })
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
