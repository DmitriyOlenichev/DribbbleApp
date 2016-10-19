//
//  AuthViewModel.swift
//  DribbbleApp
//
//  Created by Admin on 21.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MBProgressHUD

class AuthViewModel {
    private let disposeBag = DisposeBag()
    
    let loginStatus = AuthManager.sharedInstance.status.asDriver().asDriver(onErrorJustReturn: .none)
   
    init() {}
    init(loginTrigger: Observable<Void>, viewController: AuthViewController) {

        loginTrigger
            .bindNext { _ in
                    AuthManager.sharedInstance.login()

                    Helper.showHUD(viewController.view)
            }
            .addDisposableTo(disposeBag)

    }
    
}
