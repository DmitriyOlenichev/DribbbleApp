//
//  User.swift
//  DribbbleApp
//
//  Created by Admin on 17.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class AuthorObject : Object {
    dynamic var id: Int = 0
    dynamic var name: String!
    dynamic var avatarUrl: String!
    dynamic var username: String = ""
    
    override static func primaryKey() -> String? { return "username" }
    
    convenience init?(data: Dictionary<String, AnyObject>) {
        self.init()
        
        if let id = data["id"] {
            self.id = id.intValue
        } else {
            return nil
        }
        
        self.name = data["name"] as? String
        self.avatarUrl = data["avatar_url"] as? String
        
        let username = data["username"] as? String
        if username != nil {
            self.username = username!
        } else {
            return nil
        }
    }
    

}

class Author {
    let id: UInt!
    let name: String!
    let avatarUrl: String!
    let username: String
    
    var bio: String!
    var likesCount: UInt!
    var followersCount: UInt!
    
    convenience init?(fullData: Dictionary<String, AnyObject>) {
        self.init(data: fullData)
        
        self.bio = fullData["bio"] as? String
        self.likesCount = (fullData["likes_count"])?.uintValue
        self.followersCount = (fullData["followers_count"])?.uintValue
        
        if self.likesCount == nil || self.followersCount == nil || self.name == nil || self.avatarUrl == nil {
            return nil
        }
    }
    
    init?(data: Dictionary<String, AnyObject>) {
        self.id = (data["id"])?.uintValue
        self.name = data["name"] as? String
        self.avatarUrl = data["avatar_url"] as? String
        
        let username = data["username"] as? String
        if username != nil {
            self.username = username!
        } else {
            return nil
        }
    }
}

