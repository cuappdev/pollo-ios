//
//  PolloEndpoints.swift
//  Clicker
//
//  Created by Matthew Coufal on 1/30/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension Endpoint {
    
    static func getSortedPolls(with id: Int) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)/polls", headers: headers)
    }
    
}
