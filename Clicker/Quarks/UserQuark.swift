//
//  UserQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/9/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Neutron
import SwiftyJSON
import Alamofire

struct GetUser : ClickerQuark {
    
    typealias ResponseType = User
    
    let id: String
    
    var route: String {
        return "/v1/users/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> User {
        switch element {
        case .node(let node):
            guard let id = node["id"].string , let name = node["name"].string, let netid = node["netid"].string else {
                throw NeutronError.badResponseData
            }
            return User(id: id, netID: netid, name: name)
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetUserCourses : ClickerQuark {
    
    typealias ResponseType = [Course]
    
    let id: String
    let role: String?
    
    var route: String {
        return "/v1/users/\(id)/courses"
    }
    var parameters: Parameters {
        if let r = role {
            return [
                "role": r
            ]
        } else {
            return [:]
        }
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Course] {
        switch element {
        case .edges(let edges):
            let courses: [Course] = try edges.map {
                guard let id = $0.node["id"].string, let name = $0.node["name"].string, let term = $0.node["name"].string else {
                    throw NeutronError.badResponseData
                }
                return Course(id: id, name: name, term: term)
            }
            return courses
        default: throw NeutronError.badResponseData
        }
    }
    
}
