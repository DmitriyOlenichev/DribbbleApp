//
//  Comment.swift
//  DribbbleApp
//
//  Created by Admin on 17.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

struct Comment {
    let id: UInt!
    let body: String!
    let updatedAt: Date!
    let authorName: String!
    let authorAvatarUrl: String!
    
    init?(data: Dictionary<String, AnyObject>) {
        self.id = (data["id"])?.uintValue
        self.updatedAt = (data["updated_at"] as? String)?.dateFromFormat()
        
        self.body = data["body"] as? String
        if self.body == nil { return nil }
        
        if let user = data["user"] as? [String: AnyObject]{ //
            self.authorName = user["name"] as? String
            self.authorAvatarUrl = user["avatar_url"] as? String

        } else {
            debugPrint("*nilLike")
            return nil
        }
    }
}
