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

struct GetUser : JSONQuark {
    
    typealias ResponseType = User
    
    let id: Int
    
    var route: String {
        return "/v1/users/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> User {
        guard let id = response["node"]["id"].string , let name = response["node"]["name"].string, let netid = response["node"]["netid"].string else {
            throw NeutronError.badResponseData
        }
        return User(id: id, netID: netid, name: name)
    }
    
}

struct GetUserCourses : JSONQuark {
    
    typealias ResponseType = [Course]
    
    let user: User
    let role: String?
    
    var route: String {
        return "/v1/users/\(user.id)/courses"
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
    
    func process(response: JSON) throws -> [Course] {
        guard let coursesArray = response["edges"].array else {
            throw NeutronError.badResponseData
        }
        
        if coursesArray.count == 0 {
            return [Course]()
        }
        
        let courses: [Course]? = try coursesArray.map { json -> Course in
            guard let id = json["node"]["id"].string, let name = json["node"]["name"].string, let term = json["node"]["name"].string else {
                throw NeutronError.badResponseData
            }
            return Course(id: id, name: name, term: term)
        }
        if let c = courses {
            return c
        } else {
            throw NeutronError.badResponseData
        }
    }
    
}
