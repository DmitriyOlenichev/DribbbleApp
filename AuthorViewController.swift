//
//  AuthorViewController.swift
//  DribbbleApp
//
//  Created by Admin on 30.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RxSwift
import AlamofireImage

class AuthorViewController: UIViewController, UITableViewDelegate {  //UITableViewDataSource,

    @IBOutlet var mainScrollView: UIScrollView!
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameText: UILabel!
    @IBOutlet var infoText: UILabel!
    
    
    @IBOutlet var likesTab: UIButton!
    @IBOutlet var likesCountText: UILabel!
    @IBOutlet var followersTab: UIButton!
    @IBOutlet var followersCountText: UILabel!
    
   
    @IBOutlet var likesTableView: UITableView!
    @IBOutlet var followersTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var username: String = "" //passed from segue

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.uiSetup()
        
        //triggers
        let likesNextPartTrigger = self.likesTableView.rx.contentOffset
            .flatMap { _ in
                self.likesTableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Observable.just(())
                    : Observable.empty()
        }
        
        let followersNextPartTrigger = self.followersTableView.rx.contentOffset
            .flatMap { _ in
                self.followersTableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Observable.just(())
                    : Observable.empty()
        }

    
        let viewModel = AuthorViewModel(
            authorVC: self,
            username: self.username,
            uiTriggers: (
                likesTabTrigger: likesTab.rx.tap.asObservable(),
                followersTabTrigger: followersTab.rx.tap.asObservable(),
                likesNextPartTrigger: likesNextPartTrigger,
                followersNextPartTrigger: followersNextPartTrigger
                )

        )

        // Output
        viewModel.name.asObservable()
            .map { $0 }
            .bindTo(nameText.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.info.asObservable()
            .map { $0 }
            .bindTo(infoText.rx.text)
            .addDisposableTo(disposeBag)
        
        
        viewModel.likesCount.asObservable()
            .map { $0.description }
            .bindTo(likesCountText.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.followersCount.asObservable()
            .map { $0.description }
            .bindTo(followersCountText.rx.text)
            .addDisposableTo(disposeBag)
     
        _ = viewModel.avatarUrl.asObservable()
            .filter { !$0.isEmpty }
            .bindNext { url in
                guard !url.isEmpty else { return }
                
                let placeholderImage = UIImage(named: "placeholder")!
                let imageFilter = AspectScaledToFillSizeWithRoundedCornersFilter(size: CGSize(width: 100, height: 100), radius: 22.0)
                self.avatarImage.af_setImage(withURL: URL(string: url)!, placeholderImage: placeholderImage, filter: imageFilter, imageTransition: .curlUp(0.2))
            }
            .addDisposableTo(disposeBag)
        
        
        //
        viewModel.likes
            .asObservable()
            .bindTo(likesTableView.rx.items(cellIdentifier: "LikeCell", cellType: LikeTableViewCell.self)) { (row, element, cell) in
                
                cell.personNameText.text = element.ownerName.description
                cell.shotTitle.text = element.shotTitle.description
                cell.likeDate.text = element.createdAt.desc()
                
                _ = cell.personAvatar.setRoundImage(url: element.ownerAvatarUrl, width: 30.0, height: 30.0)
                
                cell.backgroundColor = row % 2 == 0 ? UIColor(red: 255/255.0, green: 179/255.0, blue: 179/255.0, alpha: 0.7) : UIColor(red: 255/255.0, green: 204/255.0, blue: 204/255.0, alpha: 0.7)
            }
            .addDisposableTo(disposeBag)
        
        viewModel.followers
            .asObservable()
            .bindTo(followersTableView.rx.items(cellIdentifier: "FollowerCell", cellType: FollowerTableViewCell.self)) { (row, element, cell) in
                
                cell.followerName.text = element.name
                cell.likesCountText.text = element.likesCount.description
                
                cell.likeImage.image = UIImage.fontAwesomeIconWithName(.Heart, textColor: UIColor.darkGray, size: CGSize(width: 25, height: 25))
     
                _ = cell.avatar.setRoundImage(url: element.avatarUrl, width: 30.0, height: 30.0)
                
                cell.backgroundColor = row % 2 == 0 ? UIColor(red: 179/255.0, green: 255/255.0, blue: 204/255.0, alpha: 1) : UIColor(red: 204/255.0, green: 255/255.0, blue: 210/255.0, alpha: 0.9)
                
            }
            .addDisposableTo(disposeBag)
       
    }
    
    func uiSetup() {
    //likesTab.setAttributedTitle(<#T##title: NSAttributedString?##NSAttributedString?#>, for: .selected)
    }

}
