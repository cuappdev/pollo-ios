//
//  PolloEndpoints.swift
//  Clicker
//
//  Created by Matthew Coufal on 1/30/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension Endpoint {
    
    
    static func getPoll(with id: Int) -> Endpoint {
        return Endpoint(path: "/polls\(id)")
    }
    
    static func getSortedPolls(with id: Int) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)/polls")
    }
    
}
