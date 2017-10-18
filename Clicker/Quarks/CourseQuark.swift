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

struct GetCourse : ClickerQuark {
    
    typealias ResponseType = Course
    
    let id: String
    
    var route: String {
        return "/v1/courses/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> Course {
        switch element {
        case .node(let node):
            guard let id = node["id"].string , let name = node["name"].string, let term = node["term"].string else {
                throw NeutronError.badResponseData
            }
            return Course(id: id, name: name, term: term)
        default: throw NeutronError.badResponseData
        }
    }
}


struct UpdateCourse : ClickerQuark {
    typealias ResponseType = Course
    
    let id: String
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
    
    func process(element: Element) throws -> Course {
        switch element {
        case .node(let node):
            guard let id = node["id"].string , let name = node["name"].string, let term = node["term"].string else {
                throw NeutronError.badResponseData
            }
            return Course(id: id, name: name, term: term)
        default: throw NeutronError.badResponseData
        }
    }
}

struct DeleteCourse: ClickerQuark {
    typealias ResponseType = Void
    
    let id: String
    var route : String {
        return "/v1/courses/\(id)"
    }
    let host : String = "http://localhost:3000"
    let method : HTTPMethod = .delete
    
    func process(element: Element) throws -> Void {
        return
    }
}
    

struct CourseAddStudents : ClickerQuark {
    
    typealias ResponseType = Void
    
    let id: String
    let studentIDs: [String]
    
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
    
    func process(element: Element) throws -> Void {
        switch element {
        case .errors(let clickerErr):
            throw clickerErr
        default: return
        }
    }
    
}


struct CourseRemoveStudents : ClickerQuark {
    
    typealias ResponseType = Void
    
    let id: String
    let studentIDs: [String]
    
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
    
    func process(element: Element) throws -> Void {
        switch element {
        case .errors(let clickerErr):
            throw clickerErr
        default: return
        }
    }
}



struct CourseAddAdmins : ClickerQuark {
    
    typealias ResponseType = Void
    
    let id: String
    let adminIDs: [String]
    
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
    
    func process(element: Element) throws -> Void {
        switch element {
        case .errors(let clickerErr):
            throw clickerErr
        default: return
        }
    }
}


struct CourseRemoveAdmins : ClickerQuark {
    
    typealias ResponseType = Void
    
    let id: String
    let adminIDs: [String]
    
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
    
    func process(element: Element) throws -> Void {
        switch element {
        case .errors(let clickerErr):
            throw clickerErr
        default: return
        }
    }
}

