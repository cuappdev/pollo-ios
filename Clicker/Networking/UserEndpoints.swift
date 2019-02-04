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
        return Endpoint(path: "/users", headers: headers)
    }
    
    static func userAuthenticate(with idToken: String) -> Endpoint {
        return Endpoint(path: "/auth/mobile", body: ["idToken": idToken])
    }
    
    static func userRefreshSession() -> Endpoint {
        return Endpoint(path: "/auth/refresh", headers: headers)
    }
    
}
