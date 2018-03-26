//
//  ClickerQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

protocol ClickerQuark: JSONQuark {
    func process(element: Element) throws -> ResponseType
}

extension ClickerQuark {
    var host: String {
        print(Keys.hostURL.value + "/api")
        return Keys.hostURL.value + "/api"
    }

    var api: APIVersion { return .versioned(1) }
    
    public func process(response: JSON) throws -> ResponseType {
        if let errors = response["data"]["errors"].array?.flatMap({ $0.string }) {
            throw ClickerError.backendError(messages: errors)
        }
        
        if response["data"]["node"].exists() {
            return try process(element: .node(response["data"]["node"]))
        }
        
        if let edges = response["data"]["edges"].array {
            let edgesTuples = edges.map {
                ("", $0["node"])
            }
            return try process(element: .edges(edgesTuples))
        }
        
        if let nodes = response["data"].array {
            if nodes.count == 0 {
                return try process(element: .nodes([JSON]()))
            } else if nodes[0]["node"].exists() {
                let nodesArr = nodes.map {
                    $0["node"]
                }
                return try process(element: .nodes(nodesArr))
            }
        }
        
        if let ports = response["data"]["ports"].array {
            let portsArr = ports.map {
                $0.intValue
            }
            return try process(element: .ports(portsArr))
        }
        
        if response["data"].exists() {
            return try process(element: .node(response["data"]))
        }
        
        return try process(element: .null)
    }
}

typealias Edge = (cursor: String, node: JSON)

enum ClickerError: Error {
    case backendError(messages: [String])
}

enum Element {
    case null
    case ports([Int])
    case node(JSON)
    case nodes([JSON])
    case edges([Edge])
}

