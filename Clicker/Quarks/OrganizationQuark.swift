//
//  OrganizationQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Neutron
import SwiftyJSON
import Alamofire

struct GetOrganization: JSONQuark {
    typealias ResponseType = Organization
    
    let id: String
    
    var route: String {
        return "/v1/organizations/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> Organization {
        guard let id = response["node"]["id"].string, let name = response["node"]["name"].string else {
            throw NeutronError.badResponseData
        }
        return Organization(id, name)
    }
}

struct CreateOrganization: JSONQuark {
    typealias ResponseType = Organization
    
    let name: String
    
    var route: String {
        return "/v1/organizations/"
    }
    var parameters: Parameters {
        return [
            "name": name
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(response: JSON) throws -> Organization {
        guard let id = response["node"]["id"].string, let name = response["node"]["name"].string else {
            throw NeutronError.badResponseData
        }
        return Organization(id, name)
    }
}

struct GetCoursesInOrganization: JSONQuark {
    typealias ResponseType = [Course]
    
    let id: String
    
    var route: String {
        return "/v1/organizations/\(id)/courses"
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

struct CreateCourseInOrganization: JSONQuark {
    typealias ResponseType = Course
    
    let id: String
    let name: String
    let term: String
    
    var route: String {
        return "/v1/organizations/\(id)/courses"
    }
    var parameters: Parameters {
        return [
            "name": name,
            "term": term
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(response: JSON) throws -> Course {
        guard let id = response["node"]["id"].string , let name = response["node"]["name"].string, let term = response["node"]["term"].string else {
            throw NeutronError.badResponseData
        }
        return Course(id: id, name: name, term: term)
    }
}

