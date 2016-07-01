//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/28/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let my_consumerKey: String! = "d6I5vFvGdL4IVAZRGb8xVwpeB"
    static let my_consumerSecret: String! = "ajwNDdkMehiuXEi1FT5Hd6WtmJYFETu9pKIwUHXBZUqXp8opAF"
    static let baseUrl: String! = "https://api.twitter.com"
    static let requestUrl: String! = "/oauth/request_token"
    static let authoUrl: String! = "/oauth/authorize"
    static let accessUrl: String! = "/oauth/access_token"
    
    let myCallBackUrl: String! = "stephaniestwitterdemo://"
    let currentAccountUrl: String! = "/1.1/account/verify_credentials.json"
    let homeTimeLineUrl: String! = "/1.1/statuses/home_timeline.json"
    let userTimeLineUrl: String! = "/1.1/statuses/user_timeline.json"
    let favoriteUrl: String! = "/1.1/favorites/create.json"
    let unfavoriteUrl: String! = "/1.1/favorites/destroy.json"
    let composeUrl: String! = "/1.1/statuses/update.json"
    let bannerUrl: String! = "/1.1/users/profile_banner.json"
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: baseUrl), consumerKey: my_consumerKey, consumerSecret: my_consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestTokenWithPath(TwitterClient.requestUrl, method: "GET", callbackURL: NSURL(string: myCallBackUrl), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: TwitterClient.baseUrl + TwitterClient.authoUrl + "?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> () ) {
        GET(currentAccountUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET(homeTimeLineUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
//            for tweet in tweets { print("\(tweet.text)") }
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func userTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET(userTimeLineUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath(TwitterClient.accessUrl, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
    
        }) { (error: NSError!) -> Void in
                print(error.localizedDescription)
                self.loginFailure?(error)
        }
    }
    
    func retweet(tweetIDStr: String!, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("/1.1/statuses/retweet/\(tweetIDStr).json", parameters: nil,
             progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
            },
             failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting")
                failure(error)
        })
    }
    
    func unretweet(tweetIDStr: String!, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("/1.1/statuses/retweet/\(tweetIDStr).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func favorite(tweetIDStr: String!, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("/1.1/favorites/create.json?id=\(tweetIDStr)", parameters: nil, progress: { (progress: NSProgress) -> Void in },success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
                print("ERROROEROROEROR")
        })
    }
    
    func unfavorite(tweetIDStr: String!, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("/1.1/statuses/destroy/\(tweetIDStr).json", parameters: nil, progress: { (progress: NSProgress) -> Void in },success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func compose(status: String!, success: () -> (), failure: (NSError) -> ()) {
        let statusParams = ["status" : status]
        POST("/1.1/statuses/update.json", parameters: statusParams, progress: nil ,success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("tweet created")
            success()
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func getBanner(success: (User) -> (), failure: (NSError) -> () ) {
        GET(bannerUrl, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
}
