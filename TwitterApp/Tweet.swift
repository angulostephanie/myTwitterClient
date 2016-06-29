//
//  Tweet.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/27/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    let textString: String! = "text"
    let retweetCountString: String! = "retweet_count"
    let favCountString: String! = "favourites_count"
    let createdAtString: String! = "created_at"
    
    var text: NSString?
    var formattedTimeStampString: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var user: User?
    
    init(dictionary: NSDictionary) {
        text = dictionary[textString] as? String
        retweetCount = (dictionary[retweetCountString] as? Int) ?? 0
        favoritesCount = (dictionary[favCountString] as? Int) ?? 0
        let userDictionary = dictionary["user"] as! NSDictionary
        
        user = User(dictionary: userDictionary)
        
        let timestampString = dictionary[createdAtString] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = formatter.dateFromString(timestampString)
            print("\(timestamp)")
            formattedTimeStampString = formatter.stringFromDate(timestamp!)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
