//
//  Shot.swift
//  DribbbleApp
//
//  Created by Admin on 16.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class Shot: Object, IdEquatable {  //
    
    dynamic var id: Int = 0  //RealmOptional<Int>()
    dynamic var url: String!
    dynamic var title: String!
    dynamic var desc: String!
    dynamic var author: AuthorObject!
    dynamic var likesCount: Int = 0
    dynamic var commentsCount: Int = 0
    dynamic var commentsUrl: String!

    
    override static func primaryKey() -> String? { return "id" }
    
    convenience init?(data: Dictionary<String, AnyObject>) {
        self.init()

        if let id = data["id"] {
            self.id = id.intValue
        } else {
            return nil
        }
        
        

        
        if let img = data["images"] as? [String: AnyObject] {
            self.url = (img["hidpi"] as? String) ?? (img["normal"] as? String)
        } else {
            print("*nillShot")
            return nil
        }
        
        self.title = data["title"] as? String
        self.desc = data["description"] as? String
        
        if data["likes_count"] != nil { self.likesCount = data["likes_count"]!.intValue }
        if data["comments_count"] != nil { self.commentsCount = data["comments_count"]!.intValue }
        
        self.commentsUrl = data["comments_url"] as? String
        self.author = AuthorObject(data: (data["user"] as? [String: AnyObject])!)
    }
    
    static func ==(a: Shot, b: Shot) -> Bool {
        return a.id == b.id//&&
    }
    override public var hash : Int { return id }
    public func isEqual(object: Shot) -> Bool { return self.id == object.id }
    

}












/*class Shot: Equatable {  //Object,
    
    let id: UInt!
    let url: String!
    let title: String!
    let desc: String!
    let author: Author!
    let likesCount: UInt!
    let commentsCount: UInt!
    let commentsUrl: String!
    
    //let comment: Comment!
    
    init?(data: Dictionary<String, AnyObject>) {
        
        //if let shotJSON = shotData as? [String: Any] {
        self.id = (data["id"])?.uintValue //UInt32((data["id"] as? UInt32)!)
        self.title = data["title"] as? String
        self.desc = data["description"] as? String
        self.likesCount = (data["likes_count"])?.uintValue
        self.commentsCount = (data["comments_count"])?.uintValue
        self.commentsUrl = data["comments_url"] as? String
        
        if let img = data["images"] as? [String: AnyObject] {
            self.url = (img["hidpi"] as? String) ?? (img["normal"] as? String)
        } else {
            print("*nillShot")
            return nil
        }
        
        self.author = Author(data: (data["user"] as? [String: AnyObject])!)
        //            let commentData : [String: Any] = ["comments_count" : shotJSON["comments_count"],
        //                                                  "comments_v" : shotJSON["comments_url"]]
        //self.comment = Comment(data: data)
    }
    
    static func ==(a: Shot, b: Shot) -> Bool {
        return a.id == b.id//&&
    }
    
    //    func equals (compareTo:PLClient) -> Bool {
    //        return
    //        self.name == compareTo.name &&
}*/

