//
//  AuthViewController.swift
//  DribbbleApp
//
//  Created by Admin on 20.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class AuthViewController: UIViewController {
    var viewModel = AuthViewModel()

    @IBOutlet var authLabel: UILabel!
    @IBOutlet var signInButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
         MBProgressHUD.hide(for: self.view, animated: true)

        viewModel = AuthViewModel(loginTrigger: signInButton.rx.tap.asObservable(), viewController: self)

        //
        signInButton.layer.cornerRadius = 8
        //signInButton.layer.borderWidth = 1.8
        //signInButton.layer.borderColor = UIColor.red.cgColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    func segueToShotsView() {
        
        self.performSegue(withIdentifier: "ShotsListSegue", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
