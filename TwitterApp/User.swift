//
//  User.swift
//  TwitterApp
//
//  Created by Stephanie Angulo on 6/27/16.
//  Copyright © 2016 Stephanie Angulo. All rights reserved.
//

import UIKit

class User: NSObject {
    static let userDidLogoutNotification = "UserDidLogout"
    static let currentUserDataKey: String! = "currentUserData"
    static var _currentUser: User?
    
    let nameString: String! = "name"
    let screennameString: String! = "screen_name"
    let profileImageUrlString: String! = "profile_image_url_https"
    let profileBackgroundImageUrlString: String! = "profile_background_image_url_https"
    let descriptionString: String! = "description"
    let idString: String! = "id"
    let followerString: String! = "followers_count"
    let followingString: String! = "friends_count"
    
    var name: NSString?
    var screename: NSString?
    var profileUrl: NSURL?
    var profileBackgroundImageURL: NSURL?
    var followers: Int?
    var following: Int?
    var tweets: Int?
    var id: Int?
    var userDescription: NSString?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        id = dictionary[idString] as? Int
        name = dictionary[nameString] as? String
        screename = dictionary[screennameString] as? String
        
        followers = dictionary[followerString] as? Int
        following = dictionary[followerString] as? Int
        
        let profileUrlString = dictionary[profileImageUrlString] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        
        let profileBackgroundString = dictionary[profileBackgroundImageUrlString] as? String
        if let profileBackgroundString = profileBackgroundString {
            profileBackgroundImageURL = NSURL(string: profileBackgroundString)
        } 
        userDescription = dictionary[descriptionString] as? String
    }
    
    
    
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey(User.currentUserDataKey) as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user){
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: User.currentUserDataKey)
            } else {
                defaults.setObject(nil, forKey: User.currentUserDataKey)
            }
            
            defaults.synchronize()
        }
    }

}
