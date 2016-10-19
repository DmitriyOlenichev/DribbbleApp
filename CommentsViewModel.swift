//
//  CommentsViewModel.swift
//  DribbbleApp
//
//  Created by Admin on 14.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import MBProgressHUD

class CommentsViewModel {
    var comments = Variable<[Comment]>([])
    
    let model = WebDataManager.sharedInstance
    
    var nextPart: UInt = 1
    let perPart: UInt = 100

    
    private let disposeBag = DisposeBag()
    
    init(addCommentTrigger: Observable<Void>, commentBody: Observable<String>, loadNextPartTrigger: Observable<Void>, shotId: UInt,  commentsVC: CommentsViewController) {
        
        //validation
        commentBody
            .map({!$0.isEmpty})
            .shareReplay(1)
            .bindTo(commentsVC.addCommentButton.rx.enabled)
            .addDisposableTo(disposeBag)
        
        addCommentTrigger
            .throttle(0.25, latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(commentBody) {

                Helper.showHUD(commentsVC.view)

                self.model.addComment(shotId: shotId, body: $1, completion: { error, comment in
                    MBProgressHUD.hide(for: commentsVC.view, animated: true)
                    
                    // чтобы добавлять комментарии нужно быть в команде дизайнеров или игроком
                    if error == nil {
                        self.comments.value.insert(comment!.value, at: 0)
                       //
                    } else {
                        if case  WebErr.forbidden = error! {
                            Helper.showAlert(commentsVC, "Access error. Probably you not player or in team",  false, "Forbidden")
                        } else {
                            Helper.showAlert(commentsVC, error!.desc, false, "Error")
                        }
                    }
                    //fake comment add test!
//                    let comment = self.addfakeComment()
//                    self.comments.value.insert(comment, at: 0)

                    
                    //
                    commentsVC.commentTextView.text = ""
                    commentsVC.addCommentButton.isEnabled = false
  
                    if commentsVC.commentsTableView.numberOfRows(inSection: 0) > 0 {
                        commentsVC.commentsTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
                    }
                })
            }
            .subscribe {
               
            }
            .addDisposableTo(disposeBag)
        
        //
        model.fetchShotComments(shotId: shotId, page: nextPart, perPage: perPart) { error, comments in
            if error == nil {
                self.comments.value.append(contentsOf: comments!.value)
                self.comments.value.sort(by: { $0.updatedAt > $1.updatedAt })
            } else {
                print(error)
            }
        }
    }
    
    
    //test
    private func addfakeComment() -> Comment {
        let data: [String : Any] = [
            "id": 33333,
            "updated_at" : "2012-03-15T04:24:39Z",
            "body": "test test test",
            "user": [
                "name" : "Test name",
                "avatar_url" : "https://d13yacurqjgara.cloudfront.net/users/1/avatars/normal/dc.jpg?1371679243"
            ]
        ]
        return Comment(data: data as Dictionary<String, AnyObject>)!
    }
}
