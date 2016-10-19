//
//  AuthorViewModel.swift
//  DribbbleApp
//
//  Created by Admin on 01.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class AuthorViewModel {
    private let model = WebDataManager.sharedInstance
    private let disposeBag = DisposeBag()
    
    let authorVC: AuthorViewController
    
    var likes = Variable([Like]())
    var followers = Variable([Follower]())

    private var part: [String : UInt] = ["likes": 0, "followers": 0]
    private var perPart: [String : UInt] = ["likes": 20, "followers": 20]
    
    var name = Variable<String>("")  //Observable<String>.empty()
    var avatarUrl = Variable<String>("")
    var info = Variable<String>("")
    var likesCount = Variable<UInt>(0)
    var followersCount = Variable<UInt>(0)
    
    init(authorVC: AuthorViewController,
         username: String,
         uiTriggers: (
            likesTabTrigger: Observable<Void>,
            followersTabTrigger: Observable<Void>,
            likesNextPartTrigger: Observable<Void>,
            followersNextPartTrigger: Observable<Void>
         )
         )
    {
        
        self.authorVC = authorVC
        
        model.fetchAuthorInfo(username: username) { err, author in
            if err == nil {
                self.name.value = author!.value.name 
                self.likesCount.value = author!.value.likesCount
                self.followersCount.value = author!.value.followersCount  
                self.info.value = author!.value.bio != nil ? author!.value.bio.stripHtml() : ""
                self.avatarUrl.value = author!.value.avatarUrl ?? ""
            } else {                
                Helper.showAlert(authorVC, err!.desc, true)
            }
        }
        
        //triggers
        uiTriggers.likesTabTrigger
            .bindNext {
                self.showLikesList()
            }
            .addDisposableTo(disposeBag)
        
        uiTriggers.followersTabTrigger
            .bindNext {
                self.showFollowersList()
            }
            .addDisposableTo(disposeBag)
        
        //
        uiTriggers.likesNextPartTrigger
            .throttle(1, latest: false, scheduler: MainScheduler.instance)
            .bindNext {
                self.part["likes"]! += 1
  
                self.model.fetchUserLikes(username: username, page: self.part["likes"]!, perPage: self.perPart["likes"]!) { likes, error in
                    if error == nil {
                        let newLikes = likes!.value.unique(of: self.likes.value)
                        self.likes.value.append(contentsOf: newLikes)
                    }
                }
            }
            .addDisposableTo(self.disposeBag)
        
        uiTriggers.followersNextPartTrigger
            .throttle(0.25, latest: false, scheduler: MainScheduler.instance)
            .bindNext {
                self.part["followers"]! += 1
                
                self.model.fetchUserFollowers(username: username, page: self.part["followers"]!, perPage: self.perPart["followers"]!) { followers, error in
                    if error == nil {
                        let newFollowers = followers!.value.unique(of: self.followers.value)
                        self.followers.value.append(contentsOf: newFollowers)

                    }
                }
            }
            .addDisposableTo(self.disposeBag)
        
    }
    
    //
    private func showLikesList() {
        hideAndUnselectTabs()
        
        authorVC.likesTableView.isHidden = false
        authorVC.likesTab.isSelected = true
      
    }
    
    private func showFollowersList() {
        hideAndUnselectTabs()
        
        authorVC.followersTableView.isHidden = false
        authorVC.followersTab.isSelected = true
      
    }
    
    private func hideAndUnselectTabs() {
        authorVC.likesTableView.isHidden = true
        authorVC.followersTableView.isHidden = true
        
        authorVC.likesTab.isSelected = false
        authorVC.followersTab.isSelected = false
    }
}
