//
//  CourseQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/9/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

struct GetCourse : ClickerQuark {
    
    typealias ResponseType = Course
    
    let id: String
    
    var route: String {
        return "/v1/courses/\(id)"
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> Course {
        switch element {
        case .node(let node):
            guard let id = node["id"].int , let name = node["name"].string, let term = node["term"].string else {
                throw NeutronError.badResponseData
            }
            return Course(id: "\(id)", name: name, term: term)
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetCourseLectures : ClickerQuark {
    
    typealias ResponseType = [Lecture]
    
    let id: String
    
    var route: String {
        return "/v1/courses/\(id)/lectures"
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get
    
    
    func process(element: Element) throws -> [Lecture] {
        switch element {
        case .edges(let edges):
            let lectures: [Lecture] = try edges.map {
                guard let id = $0.node["id"].int, let dateTime = $0.node["dateTime"].int else {
                    throw NeutronError.badResponseData
                }
                return Lecture("\(id)", "\(dateTime)")
            }
            return lectures
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
    let host: String = "http://localhost:3000/api"
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
    let host : String = "http://localhost:3000/api"
    let method : HTTPMethod = .delete
    
    func process(element: Element) throws -> Void {
        return
    }
}

// NOTE: CourseAddStudents Quark has issues sending array of strings as
// parameters. Look at AddCourseViewController for code to add students.
struct CourseAddStudents : ClickerQuark {
    
    typealias ResponseType = Void
    
    let courseCode: String
    let studentIDs: [String]
    
    var route: String {
        return "/v1/course/register/"
    }
    var parameters: Parameters {
        return [
            "courseCode": courseCode,
            "students": ["1"] // TEMP
        ]
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> Void {
        return
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
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .delete
    
    func process(element: Element) throws -> Void {
        return
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
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Void {
        return
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
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .delete
    
    func process(element: Element) throws -> Void {
        return
    }
}

