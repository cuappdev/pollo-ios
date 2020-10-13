//
//  PolloEndpoints.swift
//  Pollo
//
//  Created by Matthew Coufal on 1/30/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {
    
    // More often than not the bearer token is the accessToken, but refreshToken is required for refreshing the session
    static func headers(_ bearerToken: String = User.userSession?.accessToken ?? "") -> [String: String] {
        return ["Authorization": "Bearer \(bearerToken)"]
    }
    
    static func getSortedPolls(with id: String) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)/polls", headers: headers())
    }
    
}
