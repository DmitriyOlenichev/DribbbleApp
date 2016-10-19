//
//  Common.swift
//  DribbbleApp
//
//  Created by Admin on 15.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class Helper {
    
    static func showAlert(_ viewController: UIViewController,_ message: String = "Error",_ needSegue: Bool = true, _ title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if (needSegue) {
                _ = viewController.navigationController?.popToRootViewController(animated: true)
                 //alertController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func showHUD(_ view: UIView, _ text: String = "Loading", _ mode: MBProgressHUDMode = .annularDeterminate) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = mode //indeterminate
        hud.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        hud.isUserInteractionEnabled = false;
        hud.label.text = text
    }
}
