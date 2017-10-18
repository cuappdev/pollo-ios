//
//  ClickerQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/15/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Neutron
import SwiftyJSON
import Alamofire

protocol ClickerQuark: JSONQuark {
    func process(element: Element) throws -> ResponseType
}

extension ClickerQuark {
    public func process(response: JSON) throws -> ResponseType {
        if let errors = response["errors"].array {
            let messages = errors.flatMap { $0["message"].string }
            throw ClickerError.backendError(messages: messages)
        }
        
        if response["node"].exists() {
            return try process(element: .node(response["node"]))
        }
        
        if let edges = response["edges"].array {
            let edgesTuples = edges.map {
                ($0["cursor"].stringValue, $0["node"])
            }
            return try process(element: .edges(edgesTuples))
        }
        
        throw NeutronError.badResponseData
    }
}

typealias Edge = (cursor: String, node: JSON)

enum ClickerError: Error {
    case backendError(messages: [String])
}

enum Element {
    case node(JSON)
    case edges([Edge])
}
