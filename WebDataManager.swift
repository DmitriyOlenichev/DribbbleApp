//
//  DribbbleAPI.swift
//  DribbbleApp
//
//  Created by Admin on 16.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift


class WebDataManager {

    //private let likesUrl = "https://api.dribbble.com/v1/shots"
    private var parameters: Parameters = ["access_token": Config.accessToken]
    
    static let sharedInstance = WebDataManager()
    let authSessionManager = AuthManager.sharedInstance.sessionManager!
    private init() {}
    
    //return array of recent not animated shots or nil if some error in json
    func fetchRecentShots(page: UInt = 1, perPage: UInt = 20, completion: @escaping (_ error: WebErr?, _ shots: Variable<[Shot]>?) -> Void) {
        var parameters = self.parameters
        parameters["sort"] = "recent"
        parameters["page"] = page as UInt?
        parameters["per_page"] = perPage as UInt?
        
       
        
        Alamofire.request(Config.Urls.shots, parameters: parameters).validate().responseJSON { response in
            
            guard response.result.isSuccess else {
                completion(.server(response.result.error!.localizedDescription), nil)
                return
            }
            
            if let responseJSON = response.result.value as? [Any] {     
                let shots = Variable([Shot]())
                
                for shotJSON in responseJSON {
                    if let shotData = shotJSON as? [String: AnyObject] {
                        guard shotData["animated"] as? Bool != true else {
                            continue
                        }
                        
                        let shot = Shot(data: shotData)
                        if shot != nil {
                            shots.value.append(shot!)
                        }
                    }
                }
                completion(nil, shots)
            }
            else {
                completion(.badResponse, nil)
                return
            }
            
        }
    }
    
    // MARK: - Likes
    private func getLikesUrl(shotId: UInt) -> String {
        return Config.Urls.shots + "/" + shotId.description + "/like"
    }
    
    func isShotLiked(shotId: UInt, completion: @escaping (_ error: WebErr?, _ isLiked: Bool) -> Void) {
        let url = getLikesUrl(shotId: shotId)
        authSessionManager.request(url, method: .get).validate().responseJSON { response in

            if response.result.isSuccess {
                completion(nil, true)
            } else {
                completion(.server(response.result.error!.localizedDescription), false)
            }
            
        }
    }
    
    func likeShot(shotId: UInt, completion: @escaping (_ error: WebErr?) -> Void) {
        let url = getLikesUrl(shotId: shotId)
        authSessionManager.request(url, method: .post).validate().responseJSON { response in
            if response.result.isSuccess {
                 completion(nil)
            } else {
                 completion(.server(response.result.error!.localizedDescription))
            }
           
        }
    }
    
    func unlikeShot(shotId: UInt, completion: @escaping (_ error: WebErr?) -> Void) {
        let url = getLikesUrl(shotId: shotId)
        authSessionManager.request(url, method: .delete).validate().responseJSON { response in
            
            if response.result.isSuccess {
                completion(nil)
            } else {
                completion(.server(response.result.error!.localizedDescription))
            }
            
        }
    }
    

    func fetchUserLikes(username: String = "", page: UInt = 1, perPage: UInt = 20, completion: @escaping (_ likes:Variable<[Like]>?, _ error: WebErr?) -> Void) {
                   //no auth                                         //auth
        let url = !username.isEmpty ? Config.Urls.users + username + "/likes" : Config.Urls.user + "likes"
        
        var parameters = self.parameters
        parameters["page"] = page as UInt?
        parameters["per_page"] = perPage as UInt?
        
        Alamofire.request(url, parameters: parameters).validate().responseJSON { response in

            guard response.result.isSuccess else {
                print("*Error while fetching likes: \(response.result.error) \(response.result.description)")
                completion(nil, .server(response.result.error!.localizedDescription))
                return
            }
            
            if let responseJSON = response.result.value as? [Any] {
                
                let likes = Variable([Like]())
                for likeJSON in responseJSON {
                    if let likeData = likeJSON as? [String: AnyObject] {
                        
                        let like = Like(data: likeData)
                        if like != nil {
                            likes.value.append(like!)
                        }
                    }
                }
                completion(likes, nil)
            }
            else {
                completion(nil, .badResponse)
            }

        }
    }
    
    // MARK: - followers
    
    func fetchUserFollowers(username: String = "", page: UInt = 1, perPage: UInt = 20, completion: @escaping (_ likes:Variable<[Follower]>?, _ error: WebErr?) -> Void) {
        let url = !username.isEmpty ? Config.Urls.users + username.description + "/followers" : Config.Urls.user + "followers"
        
        var parameters = self.parameters
        parameters["page"] = page as UInt?
        parameters["per_page"] = perPage as UInt?
        
        Alamofire.request(url, parameters: parameters).validate().responseJSON { response in
            guard response.result.isSuccess else {
                completion(nil, .server(response.result.error!.localizedDescription))
                return
            }
            
            if let responseJSON = response.result.value as? [Any] {     //print("JSON: \(responseJSON)")
                
                let followers = Variable([Follower]())
                for likeJSON in responseJSON {
                    if let likeData = likeJSON as? [String: AnyObject] {
                        
                        let follower = Follower(data: likeData)
                        if follower != nil {
                            followers.value.append(follower!)
                        }
                    }
                }
                completion(followers, nil)
            }
            else {
                completion(nil, .badResponse)
            }
            
        }

    }
    
    //
    func fetchAuthorInfo(username: String, page: UInt = 1, perPage: UInt = 20, completion: @escaping (_ error: WebErr?, _ author: Variable<Author>?) -> Void) {
        let url = Config.Urls.users + username
        
        Alamofire.request(url, parameters: self.parameters).validate().responseJSON { response in
            guard response.result.isSuccess else {
                completion(.server(response.result.error!.localizedDescription), nil)
                print("*Error while fetching author: \(response.result.error)")
                return
            }
            
            if let data = response.result.value as? [String: AnyObject] {
           
                let author = Author(fullData: data)
                if author != nil {
                    completion(nil, Variable(author!))
                }
            }
            else {
                completion(.badResponse, nil)
            }
            
        }
    }
    
    //comments
    func fetchShotComments(shotId: UInt, page: UInt = 1, perPage: UInt = 100, completion: @escaping (_ error: WebErr?, _ comment: Variable<[Comment]>?) -> Void) {
        let url = Config.Urls.shots + "/" + shotId.description + "/comments"
        
        Alamofire.request(url, parameters: self.parameters).validate().responseJSON { response in
            guard response.result.isSuccess else {
                completion(.server(response.result.error!.localizedDescription), nil)
                return
            }
            
            if let responseJSON = response.result.value as? [Any] {
                let comments = Variable([Comment]())
                
                for commentJSON in responseJSON {
                    if let commentData = commentJSON as? [String: AnyObject] {

                        let comment = Comment(data: commentData)
                        if comment != nil {
                            comments.value.append(comment!)
                        }
                    }
                }
                completion(nil, comments)
            }
            else {
                completion(.badResponse, nil)
                print("*Invalid comments information received")
            }
            
        }
    }
    
    func addComment(shotId: UInt, body: String, completion: @escaping (_ error: WebErr?, _ comment: Variable<Comment>?) -> Void) {
        let url = Config.Urls.shots + "/" + shotId.description + "/comments"
        
        let parameters = ["body" : body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)]
        
        authSessionManager.request(url, method: .post, parameters: parameters).validate().responseJSON { response in //debugPrint(response)

            guard response.result.isSuccess else {
                let error: WebErr? = (response.response?.statusCode == 403) ? .forbidden : .server(response.result.error!.localizedDescription)
                completion(error, nil)
                return
            }
            
            if let data = response.result.value as? [String: AnyObject] {     //print("*JSON: \(response.result.value)")
                let comment = Comment(data: data)
                comment != nil ? completion(nil, Variable(comment!)) : completion(.badResponse, nil)
            }
            else {
                completion(.badResponse, nil)
            }
        }
        
    }
    
    
}



