//
//  ShotsTableViewController.swift
//  DribbbleApp
//
//  Created by Admin on 20.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import AlamofireImage
import FontAwesome_swift
import MBProgressHUD
import Realm
import RealmSwift

class ShotsTableViewController: UITableViewController { //, UITableViewDelegate

    @IBOutlet var logoutButton: UIBarButtonItem!
    @IBOutlet var scrollToTopButton: UIBarButtonItem!
    
    @IBOutlet var loadedShots: UIBarButtonItem!
    @IBOutlet var recentShots: UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //rxswift fix
        tableView.dataSource = nil
        
        uiSetup()

        //to viewModel
        let loadNextPartTrigger = self.tableView.rx.contentOffset
            .flatMap { _ in
                self.tableView.isNearBottomEdge(edgeOffset: 20.0)
                    ? Observable.just(())
                    : Observable.empty()
        }
        
        //
        let viewModel = ShotsViewModel(
            uiTriggers: (
                loadedShotsTrigger: loadedShots.rx.tap.asObservable(),
                recentShotsTrigger: recentShots.rx.tap.asObservable(),
                loadNextPartTrigger: loadNextPartTrigger,
                logoutTrigger: logoutButton.rx.tap.asObservable()
            ),
            shotVC: self
        )
        
        viewModel.shots
            .asObservable()
            .bindTo(tableView.rx.items(cellIdentifier: "ShotCell", cellType: ShotsTableViewCell.self)) { (row, element, cell) in
                viewModel.setupCell(cell, element)
                viewModel.setCellTriggers(cell, element)
            }
            .addDisposableTo(disposeBag)

        //tableView.rx.setDataSource(self).addDisposableTo(disposeBag)

    }

    // to prevent swipe to delete behavior
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let visibleHeight = tableView.bounds.size.height - self.navigationController!.navigationBar.frame.height - UIApplication.shared.statusBarFrame.size.height
        //if UIApplication.shared.statusBarOrientation
        if UIDevice.current.orientation.isPortrait {
            return visibleHeight / 2
        } else {
            return visibleHeight
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToAuthor") {
            
            let authorVC = segue.destination as! AuthorViewController
            let authorButton = sender as! UIButton
            let shotCell = authorButton.superview?.superview?.superview as! ShotsTableViewCell
            
            
            authorVC.username = shotCell.authorUName
        }
        if (segue.identifier == "ToComments") {
            let commentsVC = segue.destination as! CommentsViewController
            let button = sender as! UIButton
            let shotCell = button.superview?.superview as! ShotsTableViewCell
            
            commentsVC.shotId = shotCell.shotId
            debugPrint("*cell shotId: " + commentsVC.shotId.description)
        }
    }
    
    func uiSetup() {
        refreshControl?.attributedTitle = NSAttributedString(string: "refreshing...")
        //        tableView.estimatedRowHeight = 300
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
    }


}
