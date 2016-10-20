//
//  CommentsViewController.swift
//  DribbbleApp
//
//  Created by Admin on 14.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage


class CommentsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var commentsTableView: UITableView!
    
    @IBOutlet var commentsTableHeight: NSLayoutConstraint!
    @IBOutlet var commentTextView: UITextView!
 
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var addCommentButton: UIButton!
  
    @IBOutlet var toAddCommentButton: UIButton!
    
    @IBOutlet var addCommentView: UIView!

    var shotId = 0 //passed from segue
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.delegate = self
    
        let loadNextPartTrigger = self.commentsTableView.rx.contentOffset
            .flatMap { _ in
                self.commentsTableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Observable.just(())
                    : Observable.empty()
        }
        
        let viewModel = CommentsViewModel(addCommentTrigger: addCommentButton.rx.tap.asObservable(),
                                          commentBody: commentTextView.rx.text.asObservable(),
                                          loadNextPartTrigger: loadNextPartTrigger,
                                          shotId: UInt(shotId),
                                          commentsVC: self
            
        )
        
        viewModel.comments
            .asObservable()
            .bindTo(commentsTableView.rx.items(cellIdentifier: "CommentCell", cellType: CommentTableViewCell.self)) { (row, element, cell) in
                
                cell.authorName.text = element.authorName.description
                _ = cell.authorAvatar.setRoundImage(url: element.authorAvatarUrl, width: 25, height: 25)
                cell.commentText.text = element.body.stripHtml()
                cell.commentDate.text = element.updatedAt.desc()

                cell.backgroundColor = row % 2 == 0 ? UIColor(red: 183/255.0, green: 245/255.0, blue: 245/255.0, alpha: 0.7) : UIColor(red: 205/255.0, green: 245/255.0, blue: 254/255.0, alpha: 0.7)
            }
            .addDisposableTo(disposeBag)
        
        //
        commentsTableView.rx.observe(CGSize.self, "contentSize")  // contentSize.type(of: dynamicType)  CGSize.self
            .throttle(0.2, latest: true, scheduler: MainScheduler.instance)
            .filter { $0?.height != nil && self.navigationController != nil}
            .bindNext { size in
                self.updateCommentsTableHeight(size!.height)
        }
        .addDisposableTo(disposeBag)
        
        //
        uiSetup()
    }
    
    func updateCommentsTableHeight(_ currHeight: CGFloat) {
        let limitHeight = self.view.frame.height - self.navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.size.height - 135 //.frame.origin.y
      
        if currHeight > limitHeight {
            self.commentsTableHeight.constant = limitHeight
        } else {
            self.commentsTableHeight.constant = currHeight
        }

    }
    
    func uiSetup() {
        
        //
        commentsTableView.estimatedRowHeight = 100
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        
        //
        addCommentButton.backgroundColor = UIColor.clear
        addCommentButton.layer.cornerRadius = 5
        addCommentButton.layer.borderWidth = 0.6
        addCommentButton.layer.borderColor = UIColor.gray.cgColor
        //addCommentButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 6, bottom: 4, right: 6)
        
        //
        commentTextView.layer.cornerRadius = 7.0;
        commentTextView.layer.borderWidth = 1.0
        
    }

    // to prevent swipe to delete behavior
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
