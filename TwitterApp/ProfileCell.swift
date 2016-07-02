//
//  ProfileCell.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/30/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var hasBeenRetweeted: Bool = false
    var hasBeenFavorited: Bool = false
    var tweetIdStr : String?
    
    var tweet: Tweet! {
        didSet {
            tweetBodyLabel.text = tweet.text!
            nameLabel.text = tweet.user?.name as? String
            usernameLabel.text = "@" + (tweet.user?.screename as? String)!
            profileImageView.af_setImageWithURL((tweet.user?.profileUrl)!)
            timestampLabel.text = tweet.formattedTimeStampString!
            favoriteLabel.text = String(tweet.favoriteCount)
            tweetIdStr = String(tweet.tweetID)
            
            if tweet.retweetCount == 0 {
                retweetLabel.text = ""
            } else {
                retweetLabel.text = String(tweet.favoriteCount)
            }
            if tweet.favoriteCount == 0 {
                favoriteLabel.text = ""
            } else {
                favoriteLabel.text = String(tweet.favoriteCount)
            }
            
            hasBeenRetweeted = tweet.retweetedByCurrentUser!
            hasBeenFavorited = tweet.favoritedByCurrentUser!
            
           if hasBeenRetweeted {
                //retweetButton.setImage(UIImage(named: "greenretweet.png"), forState: UIControlState.Normal)
           }
           
            if hasBeenFavorited {
                //favoriteButton.setImage(UIImage(named: "red_heart.png"), forState: UIControlState.Normal)
            }
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

        // Configure the view for the selected state
    }

}
