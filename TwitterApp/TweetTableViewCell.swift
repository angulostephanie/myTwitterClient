//
//  TweetTableViewCell.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/28/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tweetBodyLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var tweet: Tweet! {
        didSet {
            tweetBodyLabel.text = tweet.text as? String
            nameLabel.text = tweet.user?.name as? String
            usernameLabel.text = tweet.user?.screename as? String
            //timestampLabel.text = tweet.timestamp as? NSDate
            

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
