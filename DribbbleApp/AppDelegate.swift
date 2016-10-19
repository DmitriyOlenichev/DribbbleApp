//
//  AppDelegate.swift
//  DribbbleApp
//
//  Created by Admin on 14.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RealmSwift
import Realm
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AuthManager.sharedInstance.setup()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewId: String = "AuthViewController"
        if AuthManager.sharedInstance.isAuthorized() {
            initialViewId = "MainNavigationController"
            //initialViewId = "ShotsTableViewController"
            //initialViewId = "AuthorViewController"
        }

        let initialViewController = storyboard.instantiateViewController(withIdentifier: initialViewId)
        self.window?.rootViewController = initialViewController
        //self.window?.makeKeyAndVisible()
        
        AuthManager.sharedInstance.status
            .asDriver()
            .asDriver(onErrorJustReturn: .none)
            .drive(onNext: { [unowned self] status in
                var initialViewId: String
                
                switch status {
                case .none:
                    initialViewId = "AuthViewController"
                case .error(let err):
                    Helper.showAlert((self.window?.rootViewController)!, err.desc, false, "Auth error")
                    initialViewId = "AuthViewController"
                case .user(_):  
                    initialViewId = "MainNavigationController"
                }
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: initialViewId)
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                })
        .addDisposableTo(disposeBag)
        
         return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == "dribbbleapp" {
            AuthManager.sharedInstance.oauth2.handleRedirectURL(url)
            return true
        }
        return false
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

