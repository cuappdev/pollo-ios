//
//  UserQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/9/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

struct GetUser : ClickerQuark {
    
    typealias ResponseType = User
    
    let id: String
    
    var route: String {
        return "/v1/users/\(id)"
    }
    let host: String = "http://localhost:3000/api"
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
            return ["role": "student"] 
        }
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Course] {
        switch element {
            case .nodes(let nodes):
                let courses:[Course] = try nodes.map {
                    guard let id = $0["id"].int, let name = $0["name"].string, let term = $0["term"].string else {
                        print("failed to get user courses")
                        throw NeutronError.badResponseData
                    }
                    return Course(id: "\(id)", name: name, term: term)
                }
                return courses
            default:
                return [Course]()
        }
    }
}
