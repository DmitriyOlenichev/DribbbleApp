//
//  AuthManager.swift
//  DribbbleApp
//
//  Created by Admin on 21.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire
import RxSwift



class AuthManager {
    
    static let sharedInstance = AuthManager()
    private init() {}
    
    var sessionManager: SessionManager! = nil
    
    var status = Variable(AuthStatus.none)
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": Config.clientId, //accessToken,
        "client_secret": Config.secretToken,
        "authorize_uri": Config.Urls.authorize,
        "token_uri": Config.Urls.token,   // code grant only
        "redirect_uris": [Config.appScheme + "://oauth/callback"], //["myapp://oauth/callback"], // register your own "myapp" scheme in Info.plist
        "scope": Config.scope,  //"user repo:status"  public+write+comment+upload
        ] as OAuth2JSON)
    
    func setup() {  //_ webVC: UIViewController
        if isAuthorized() {
            status.value = .user
        }
        
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: oauth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        self.sessionManager = sessionManager   // you must hold on to this somewhere
        

    }
    
    func logout() {
        oauth2.forgetTokens()
        oauth2.abortAuthorization()
        
        status.value = .none  
    }
    
    func isAuthorized() -> Bool{
        //oauth2.accessToken != nil ? debugPrint("**token isAuthorized() yes : " + oauth2.accessToken!) : debugPrint("**token isAuthorized() is nil")
        
        return oauth2.accessToken != nil
    }
    
    
    func login() {
        sessionManager.request(Config.Urls.user).validate().responseJSON { response in
            //debugPrint(response)
            if let data = response.result.value as? [String: Any] {
                debugPrint(data)
                //status = .user((data["user"] as! String?) ?? "*unnown*")  //data["user"]
                self.status.value = .user
            }
            else {
                //self.didCancelOrFail(OAuth2Error.generic("\(response)"))
                self.status.value = .error(.server(OAuth2Error.generic(response.description).description))
               
            }
        }
    }

}
