//
//  CourseQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/9/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Neutron
import SwiftyJSON
import Alamofire

struct GetCourse : JSONQuark {
    
    typealias ResponseType = Course
    
    let id: Int
    
    var route: String {
        return "/v1/courses/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> Course {
        guard let id = response["node"]["id"].string , let name = response["node"]["name"].string, let term = response["node"]["term"].string else {
            throw NeutronError.badResponseData
        }
        return Course(id: id, name: name, term: term)
    }
    
}


struct UpdateCourse : JSONQuark {
    typealias ResponseType = Course
    
    let id: Int
    let name: String
    let term: String
    
    var route: String {
      return "/v1/courses/\(id)"
    }
    var parameters: Parameters {
        return [
            "name": name,
            "term": term
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .put
    
    func process(response: JSON) throws -> Course {
        guard let id = response["node"]["id"].string , let name = response["node"]["name"].string, let term = response["node"]["term"].string else {
            throw NeutronError.badResponseData
        }
        return Course(id: id, name: name, term: term)
    }
}

struct DeleteCourse: JSONQuark {
    typealias ResponseType = Void
    
    let id: Int
    var route : String {
        return "/v1/courses/\(id)"
    }
    let host : String = "http://localhost:3000"
    let method : HTTPMethod = .delete
    
    func process(response: JSON) throws -> Void {
        return
    }
}
    

struct CourseAddStudents : JSONQuark {
    
    typealias ResponseType = Void
    
    let id: Int
    let studentIDs: [String]
    
    // NOTE: Not sure if this is the correct way to pass an array in a query URL
    var route: String {
        return "/v1/courses/\(id)/students"
    }
    var parameters: Parameters {
        return [
            "students": studentIDs
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    
    func process(response: JSON) throws -> Void {
        if let err = response["errors"].array {
            throw NeutronError.badUrl
        }
        
    }
    
}


struct CourseRemoveStudents : JSONQuark {
    
    typealias ResponseType = Void
    
    let id: Int
    let studentIDs: [String]
    
    // NOTE: Not sure if this is the correct way to pass an array in a query URL
    var route: String {
        return "/v1/courses/\(id)/students"
    }
    var parameters: Parameters {
        return [
            "ids": studentIDs
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .delete
    
    
    func process(response: JSON) throws -> Void {
        if let err = response["errors"].array {
            throw NeutronError.badUrl
        }
        
    }
    
}



struct CourseAddAdmins : JSONQuark {
    
    typealias ResponseType = Void
    
    let id: Int
    let adminIDs: [String]
    
    // NOTE: Not sure if this is the correct way to pass an array in a query URL
    var route: String {
        return "/v1/courses/\(id)/admins"
    }
    var parameters: Parameters {
        return [
            "ids": adminIDs
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .put
    
    
    func process(response: JSON) throws -> Void {
        if let err = response["errors"].array {
            throw NeutronError.badUrl
        }
        
    }
    
}


struct CourseRemoveAdmins : JSONQuark {
    
    typealias ResponseType = Void
    
    let id: Int
    let adminIDs: [String]
    
    // NOTE: Not sure if this is the correct way to pass an array in a query URL
    var route: String {
        return "/v1/courses/\(id)/admins"
    }
    var parameters: Parameters {
        return [
            "ids": adminIDs
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .delete
    
    
    func process(response: JSON) throws -> Void {
        if let err = response["errors"].array {
            throw NeutronError.badUrl
        }
        
    }
    
}

