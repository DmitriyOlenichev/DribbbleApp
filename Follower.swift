//
//  Follower.swift
//  DribbbleApp
//
//  Created by Admin on 16.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

struct Follower : Equatable {
    let id: UInt!
    let name: String!
    let avatarUrl: String!
    
    let likesCount: UInt!
    
    init?(data: Dictionary<String, AnyObject>) {  //likes_count
        self.id = (data["id"])?.uintValue
        if self.id == nil { return nil }
        
        if let follower = data["follower"] as? [String: AnyObject] {
            self.name = follower["name"] as? String
            self.avatarUrl = follower["avatar_url"] as? String
            self.likesCount = (follower["likes_count"])?.uintValue
        } else {
            debugPrint("*nilFollower")
            return nil
        }
        
    }
    
    static func ==(a: Follower, b: Follower) -> Bool {
        return a.id == b.id//&&
    }
}
