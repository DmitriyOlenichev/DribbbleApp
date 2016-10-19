//
//  ShotsViewModel.swift
//  DribbbleApp
//
//  Created by Admin on 25.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RxRealm
import RealmSwift
import UIKit
import Alamofire
import AlamofireImage

class ShotsViewModel {
    private let model = WebDataManager.sharedInstance
    private let realm = try! Realm()
    
    private let shotVC: ShotsTableViewController
    private var refreshControl: UIRefreshControl? //
    
    private var isRecentTab: Bool = true
    private var isLoading = false
    private let disposeBag = DisposeBag()
    
    var shots = Variable<[Shot]>([]) 

    var nextPart: UInt = 1
    let perPart: UInt = 12
    
    init(uiTriggers: (
            loadedShotsTrigger: Observable<Void>,
            recentShotsTrigger: Observable<Void>,
            loadNextPartTrigger: Observable<Void>,
            logoutTrigger: Observable<Void>
        ),
         shotVC: ShotsTableViewController
        )
    {
        
        self.shotVC = shotVC
        self.refreshControl = self.shotVC.refreshControl
        
        if realm.objects(Shot.self).count > 0 {
            self.showLoadedTab()
        } else {
            self.showRecentTab()
        }

        //refresh data
        self.refreshControl?.rx
            .controlEvent(.valueChanged)
            .throttle(0.25, scheduler: MainScheduler.instance)
            .filter { _ -> Bool in
                return self.isRecentTab
            }
            .bindNext { _ in    //[weak this] in
                self.reloadData() { isSuccess, err in
                    self.refreshControl?.endRefreshing()
                    if err != nil {
                        Helper.showAlert(self.shotVC, err!.desc, false)
                    }
                }
            }
            .addDisposableTo(disposeBag)

        uiTriggers.loadNextPartTrigger
            .filter { _ -> Bool in
                return self.isRecentTab
            }
            .throttle(0.25, latest: false, scheduler: MainScheduler.instance)
            .bindNext {
                debugPrint("*more shots load")
                
                self.appendNextPart() { isSuccess, err in
                    if err != nil {
                        Helper.showAlert(self.shotVC, err!.desc, false)
                    }
                }
            }
        .addDisposableTo(self.disposeBag)

        //tabs
        uiTriggers.loadedShotsTrigger
            .subscribe(onNext: {
                self.showLoadedTab()
            })
            .addDisposableTo(self.disposeBag)
        
        uiTriggers.recentShotsTrigger
            .subscribe(onNext: {
                self.showRecentTab()
            })
            .addDisposableTo(self.disposeBag)

        //logout
        uiTriggers.logoutTrigger
            .subscribe(onNext: {
                AuthManager.sharedInstance.logout()
            })
            .addDisposableTo(self.disposeBag)
        
        //to cache
        self.shots.asObservable()
            .filter { _ -> Bool in
                return self.isRecentTab
            }
            /*.map {
             $0.filter {
             return self.realm.objects(Shot.self).filter("id = %@", $0.id).count == 0
             }
             }*/
            .subscribe(
                onNext: { shots in
                    //for i in 0..<shots.count {
                    try! self.realm.write {
                        self.realm.add(shots, update: true)
                    }
                    //}
                },
                onError: { _ in
                    print("*add to cache error")
            })
            .addDisposableTo(self.disposeBag)
        
        //        try! self.realm.write {
        //            //self.realm.delete(Shot)
        //            self.realm.deleteAll()
        //        }

    }

    func getFromCache() { debugPrint("*get from cache")
        self.shots.value = realm.objects(Shot.self).sorted(byProperty: "likesCount", ascending: false).toArray() //.sorted(byProperty: "id", ascending: false)
    }
    
    func appendNextPart(part: UInt = 1, completion: @escaping (Bool, WebErr?) -> Void) {
        guard self.isLoading != true else { return }
        self.isLoading = true
        
        model.fetchRecentShots(page: self.nextPart, perPage: self.perPart) { err, shots in
            if err == nil {
                let newShots = shots!.value.uniqueById(of: self.shots.value)
                
                self.shots.value.append(contentsOf: newShots)
                self.nextPart += 1
                self.isLoading = false
                
                completion(true, nil)
            }
            else {
                completion(false, err)
            }

        }
    }
    
    func reloadData(completion: @escaping (Bool, WebErr?) -> Void) {
        model.fetchRecentShots(page: 1, perPage: self.perPart) { err, shots in
            if err == nil {
                self.shots.value = shots!.value
                self.nextPart = 1
                
                completion(true, nil)
            }
            else {
                completion(false, err)
            }
        }
    }
    
    
    //configure!
    func setupCell(_ cell: ShotsTableViewCell,_ element: Shot) {
        
        //for segue pass
        cell.authorUName = element.author.username
        cell.shotId = element.id
        //
        cell.titleText.text = element.title
        cell.authorButton.setTitle(element.author.name, for: .normal)
        cell.likeCountText.text = element.likesCount.description
        cell.descriptionText.text = element.desc != nil ? element.desc.stripHtml() : ""
        
        cell.likeButton.titleLabel?.font = UIFont.fontAwesomeOfSize(25)
        cell.likeButton.setTitle(String.fontAwesomeIconWithName(.Heart), for: .normal)
        cell.likeButton.isSelected = false

        //быстро приводит к 429, тут или каждый лайк проверять или все страницы списка лайков юзера выбирать и сверять
        self.model.isShotLiked(shotId: UInt(element.id), completion: { error, isLiked in
            if isLiked {
                cell.likeButton.isSelected = true
            }
        })

        let placeholderImage = UIImage(named: "placeholder")!
        let filter = AspectScaledToFillSizeFilter(size: cell.shotImage.frame.size)
        cell.shotImage.af_setImage(withURL: URL(string: element.url)!, placeholderImage: placeholderImage, filter: filter, imageTransition: .crossDissolve(0.2))
    }
    
    func setCellTriggers(_ cell: ShotsTableViewCell, _ element: Shot) {
        //
        cell.likeButton.rx.tap
            .subscribe(onNext: {
                debugPrint("*like button tap")
                
                self.model.isShotLiked(shotId: UInt(element.id), completion: { error, isLiked in
                    if !isLiked {
                        self.model.likeShot(shotId: UInt(element.id), completion: { error in
                            if error == nil {
                                cell.likeButton.isSelected = true
                                cell.likeCountText.text = (UInt(cell.likeCountText.text!)! + 1).description
                            } else { print(error!) }
                        })
                    }
                    else {
                        self.model.unlikeShot(shotId: UInt(element.id), completion: { error in
                            if error == nil {
                                debugPrint("**unlikeShot success!")
                                cell.likeButton.isSelected = false
                                cell.likeCountText.text = (UInt(cell.likeCountText.text!)! - 1).description
                            } else { print(error) }
                        })
                    }
                    
                })
            })
            .addDisposableTo(cell.disposeBag)
    }
    
    func animateScreen(completion: @escaping (Bool) -> Void) {
        self.shotVC.tableView.isScrollEnabled = true
        self.shotVC.tableView.alpha = 0.2
        
        UITableView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.shotVC.tableView.alpha = 1
            }, completion: { completed in
            completion(completed)
        })
    }
    
    private func showRecentTab() {
        self.clearTabs()
        
        self.isRecentTab = true
        
        self.refreshControl?.endRefreshing()
        self.shotVC.refreshControl = self.refreshControl
        
        self.shotVC.recentShots.tintColor = UIColor.blue
   
        self.reloadData() { isSuccess, err in
            if err != nil {
                Helper.showAlert(self.shotVC, err!.desc, false)
            }
        }
        self.animateScreen() { _ in }
    }
    
    private func showLoadedTab() {
        self.clearTabs()
        
        self.isRecentTab = false
        
        self.shotVC.refreshControl = nil
        
        self.shotVC.loadedShots.tintColor = UIColor.blue
        
        self.animateScreen() { _ in }
        self.getFromCache()
        //self.shotVC.tableView.contentOffset = CGPoint.init(x: 0, y: 0 - self.shotVC.refreshControl!.frame.size.height)

    }
    
    private func clearTabs() {
        self.shots.value = []
        
        self.shotVC.recentShots.tintColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1)
        self.shotVC.loadedShots.tintColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 255/255.0, alpha: 1)
    }


    
}



