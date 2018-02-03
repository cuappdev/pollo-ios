////
////  OrganizationQuark.swift
////  Clicker
////
////  Created by Kevin Chan on 10/14/17.
////  Copyright © 2017 CornellAppDev. All rights reserved.
////
//
//import Alamofire
//import Neutron
//import SwiftyJSON
//
//struct GetOrganization: ClickerQuark {
//    typealias ResponseType = Organization
//    
//    let id: String
//    
//    var route: String {
//        return "/v1/organizations/\(id)"
//    }
//    let host: String = "http://localhost:3000/api"
//    let method: HTTPMethod = .get
//    
//    func process(element: Element) throws -> Organization {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Organization(id, name)
//        default: throw NeutronError.badResponseData
//        }
//    }
//}
//
//struct CreateOrganization: ClickerQuark {
//    typealias ResponseType = Organization
//    
//    let name: String
//    
//    var route: String {
//        return "/v1/organizations/"
//    }
//    var parameters: Parameters {
//        return [
//            "name": name
//        ]
//    }
//    let host: String = "http://localhost:3000/api"
//    let method: HTTPMethod = .post
//    
//    func process(element: Element) throws -> Organization {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Organization(id, name)
//        default: throw NeutronError.badResponseData
//        }
//    }
//}
//
//struct GetCoursesInOrganization: ClickerQuark {
//    typealias ResponseType = [Course]
//    
//    let id: String
//    
//    var route: String {
//        return "/v1/organizations/\(id)/courses"
//    }
//    let host: String = "http://localhost:3000/api"
//    let method: HTTPMethod = .get
//    
//    func process(element: Element) throws -> [Course] {
//        switch element {
//        case .edges(let edges):
//            let courses: [Course] = try edges.map {
//                guard let id = $0.node["id"].string, let name = $0.node["name"].string, let term = $0.node["name"].string else {
//                    throw NeutronError.badResponseData
//                }
//                return Course(id: id, name: name, term: term)
//            }
//            return courses
//        default: throw NeutronError.badResponseData
//        }
//    }
//}
//
//struct CreateCourseInOrganization: ClickerQuark {
//    typealias ResponseType = Course
//    
//    let id: String
//    let name: String
//    let term: String
//    
//    var route: String {
//        return "/v1/organizations/\(id)/courses"
//    }
//    var parameters: Parameters {
//        return [
//            "name": name,
//            "term": term
//        ]
//    }
//    let host: String = "http://localhost:3000/api"
//    let method: HTTPMethod = .post
//    
//    func process(element: Element) throws -> Course {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string , let name = node["name"].string, let term = node["term"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Course(id: id, name: name, term: term)
//        default: throw NeutronError.badResponseData
//        }
//    }
//}
//
