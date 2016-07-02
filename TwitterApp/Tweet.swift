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
    let idString: String! = "id_str"
    let favString: String! = "favorited"
    let retweetString: String! = "retweeted"
    
    var user: User?
    var userID: String?
    var tweetIDStr: String!
    var tweetID: Int?
    var text: String?
    var formattedTimeStampString: String?
    var timestamp: NSDate?
    var retweetCount: Int!
    var favoriteCount: Int!
    var retweetedByCurrentUser: Bool? = false
    var wasRetweeted = false
    var wasRetweetedBy: String?
    var favoritedByCurrentUser: Bool? = false
    
    init(dictionary: NSDictionary) {
        let retweetedTweet = dictionary["retweeted_status"]
        if let retweetedTweet = retweetedTweet {
            let userDictionary = retweetedTweet["user"] as? NSDictionary
            user = User(dictionary: userDictionary!)
            
            tweetIDStr = retweetedTweet[idString] as? String
            tweetID = Int(tweetIDStr!)
            text = retweetedTweet[textString] as? String
            retweetCount = (retweetedTweet[retweetCountString] as? Int) ?? 0
            favoriteCount = (retweetedTweet[favCountString] as? Int) ?? 0
            wasRetweeted = true
            wasRetweetedBy = dictionary["user"]!["name"] as? String
            userID = (user?.id)! as String
            let timestampString = retweetedTweet[createdAtString] as? String
            if let timestampString = timestampString {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                timestamp = formatter.dateFromString(timestampString)
                formattedTimeStampString = timestamp!.shortTimeAgoSinceNow()
            }
        } else {
            let userDictionary = dictionary["user"] as! NSDictionary
            user = User(dictionary: userDictionary)
            userID = (user?.id)! as String
            tweetIDStr = dictionary["id_str"] as? String
            tweetID = Int(tweetIDStr!)
            text = dictionary[textString] as? String
            retweetCount = (dictionary[retweetCountString] as? Int) ?? 0
            favoriteCount = (dictionary[favCountString] as? Int) ?? 0
            wasRetweeted = false
            
            let timestampString = dictionary[createdAtString] as? String
            if let timestampString = timestampString {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
                
                timestamp = formatter.dateFromString(timestampString)
                formattedTimeStampString = timestamp!.shortTimeAgoSinceNow()
            }
    }
        retweetedByCurrentUser = dictionary["retweeted"] as? Bool
        favoritedByCurrentUser = dictionary["favorited"] as? Bool
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
