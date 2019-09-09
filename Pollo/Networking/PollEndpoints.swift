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
    
    static var headers: [String: String] {
        return [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }
    
    static func getSortedPolls(with id: Int) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)/polls", headers: headers)
    }
    
}
