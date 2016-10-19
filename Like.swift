//
//  Like.swift
//  DribbbleApp
//
//  Created by Admin on 02.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

struct Like : Equatable {
    let id: UInt!
    let ownerName: String!
    let ownerAvatarUrl: String!
    let createdAt: Date!
    let shotTitle: String!
    
    init?(data: Dictionary<String, AnyObject>) { //debugPrint("*likeData" + data.description)
        self.id = (data["id"])?.uintValue
        if self.id == nil { return nil }
        
        self.createdAt = (data["created_at"] as? String)?.dateFromFormat()

        if let shot = data["shot"] as? [String: AnyObject], let user = shot["user"] as? [String: AnyObject]{ //
            self.ownerName = user["name"] as? String
            self.ownerAvatarUrl = user["avatar_url"] as? String
            self.shotTitle = shot["title"] as? String
        } else {
            debugPrint("*nilLike")
            return nil
        }

    }
    
    static func ==(a: Like, b: Like) -> Bool {
        return a.id == b.id//&&
    }
}
