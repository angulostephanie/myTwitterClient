//
//  Tweet.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/27/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit
import DateTools

class Tweet: NSObject {
    let textString: String! = "text"
    let retweetCountString: String! = "retweet_count"
    let favCountString: String! = "favorite_count"
    let createdAtString: String! = "created_at"
    let idString: String! = "id"
    let favString: String! = "favorited"
    let retweetString: String! = "retweeted"
    
    var user: User?
    var userID: Int?
    var tweetID: Int?
    var text: String?
    var formattedTimeStampString: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var retweeted = false
    
    var favoriteCount: Int = 0
    var favorited = false
    
    
    
    init(dictionary: NSDictionary) {
        tweetID = dictionary[idString] as? Int
        text = dictionary[textString] as? String
        retweetCount = (dictionary[retweetCountString] as? Int) ?? 0
        favoriteCount = (dictionary[favCountString] as? Int) ?? 0
        favorited = dictionary[favString] as? Bool ?? false
        retweeted = dictionary[retweetString] as? Bool ?? false
        
        let userDictionary = dictionary["user"] as! NSDictionary
        user = User(dictionary: userDictionary)
        
        let timestampString = dictionary[createdAtString] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            
            timestamp = formatter.dateFromString(timestampString)
            formattedTimeStampString = timestamp!.shortTimeAgoSinceNow()
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
