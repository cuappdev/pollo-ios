//
//  UserEndpoints.swift
//  Pollo
//
//  Created by Matthew Coufal on 2/3/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {
    
    static func getMe() -> Endpoint {
        return Endpoint(path: "/users", headers: headers())
    }
    
    static func userRefreshSession(with bearerToken: String) -> Endpoint {
        return Endpoint(path: "/auth/refresh", headers: headers(bearerToken), method: .post)
    }
    
}
