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
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: baseUrl), consumerKey: my_consumerKey, consumerSecret: my_consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath(TwitterClient.requestUrl, method: "GET", callbackURL: NSURL(string: "stephaniestwitterdemo://"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: TwitterClient.baseUrl + TwitterClient.authoUrl + "?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> () ) {
        GET("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func homeTimeLine(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("/1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
//            for tweet in tweets {
//                print("\(tweet.text)")
//            }
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
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
}
