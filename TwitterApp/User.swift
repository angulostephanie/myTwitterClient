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
    static var _currentUser: User?
    static let currentUserDataKey: String! = "currentUserData"
    
    let nameString: String! = "name"
    let screennameString: String! = "screen_name"
    let profileImageUrlString: String! = "profile_image_url_https"
    let descriptionString: String! = "description"
    
    
    var name: NSString?
    var screename: NSString?
    var profileUrl: NSURL?
    var userDescription: NSString?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary[nameString] as? String
        screename = dictionary[screennameString] as? String
        let profileUrlString = dictionary[profileImageUrlString] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
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
