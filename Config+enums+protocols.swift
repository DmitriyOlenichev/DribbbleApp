//
//  configs.swift
//  DribbbleApp
//
//  Created by Admin on 03.10.16.
//  Copyright © 2016 Admin. All rights reserved.
//

struct Config {
    static let accessToken = "84593046195905c2c0a3b56df7fdeb7be4c48c86d015cfcc6457c1961803649c"
    static let secretToken = "48057cf06414469c1f64c5cf4f7257491af7ea7430357cc1f3fada9391cc11d6"
    static let clientId = "b7a4ed87ac37a7f39e7a660bef89ad0343fe77e9d55a376fa00676b6177851b3"
    
    static let appScheme = "dribbbleapp"
    static let scope = "public write comment upload" //"public+write+comment+upload"
    
    struct Urls {
        static let token = "https://dribbble.com/oauth/token"  //POST
        
        static let authorize = "https://dribbble.com/oauth/authorize"  //GET
        
        static let baseApi = "https://api.dribbble.com/v1/"
        static let shots = "https://api.dribbble.com/v1/shots"
        static let user = baseApi + "user"
        static let users = baseApi + "users/"
    }
    
}

enum WebErr: Error {
    case server(String)
    case badResponse
    case forbidden

    var desc: String {
        get {
            switch(self) {
            case .server(let text):
                return text
                //return "server error"
            case .badResponse:
                return "Invalid data received"
            case .forbidden:
                return "Access denied"
            }
        }
    }
}

enum AuthStatus {
    case none
    case error(WebErr)
    case user   //(String)
}


enum WebError: Error {
    case server //(String)
    case badResponse //(String)
    case badCredentials //(String)
}

enum ButtonState {
    case normal
    case selected
    case disabled
    case focused    
}

//
protocol IdEquatable {
    var id: Int { get set }
}
