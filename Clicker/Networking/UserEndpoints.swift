//
//  UserEndpoints.swift
//  Clicker
//
//  Created by Matthew Coufal on 2/3/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension Endpoint {
    
    static func getMe() -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/users", headers: headers)
    }
    
    static func userAuthenticate(with idToken: String) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/auth/mobile", headers: headers, body: ["idToken": idToken])
    }
    
    static func userRefreshSession() -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/auth/refresh", headers: headers)
    }
    
}
