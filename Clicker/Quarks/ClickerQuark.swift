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
    public func process(response: JSON) throws -> ResponseType {
        print(response)
        if let errors = response["data"]["errors"].array {
            let messages = errors.flatMap { $0["message"].string }
            throw ClickerError.backendError(messages: messages)
        }
        
        if response["data"]["node"].exists() {
            return try process(element: .node(response["data"]["node"]))
        }
        
        if let edges = response["data"]["edges"].array {
            let edgesTuples = edges.map {
                //($0["cursor"].stringValue, $0["node"])
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
            let portsArr = try ports.map { json -> String in
                if let i = json.int {
                    return String(describing: i)
                } else {
                    throw ClickerError.backendError(messages: ["could not convert port to int"])
                }
            }
            return try process(element: .ports(portsArr))
        }
        
        if let data = response["data"] as? JSON {
            return try process(element: .node(data))
        }
        
        return try process(element: .null) // For when no response is returned
    }
}

typealias Edge = (cursor: String, node: JSON)

enum ClickerError: Error {
    case backendError(messages: [String])
}

enum Element {
    case null
    case ports([String])
    case node(JSON)
    case nodes([JSON])
    case edges([Edge])
}

