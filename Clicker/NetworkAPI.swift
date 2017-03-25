//
//  NetworkAPI.swift
//  Clicker
//
//  Created by AE7 on 3/5/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLConvertible {
    static let baseURL = "http://clicker-dev.us-west-2.elasticbeanstalk.com"
    
    case signIn
    case makeClass, searchClasses, getClasses, joinClass(Int), updateClass, deleteClass
    
    func asURL() throws -> URL {
        let route: String = {
            switch self {
            case .signIn: return "/auth/signin"
            case .makeClass, .searchClasses, .deleteClass: return "/classes"
            case .getClasses: return "/classes/enrolled"
            case .joinClass(let id): return "/classes/join/\(id)"
            case .updateClass(let id): return "/classes/update/\(id)"
            }
        }()
        
        return URL(string: Router.baseURL + route)!
    }
}


class NetworkAPI {
    
    static func login(_ idToken: String) {
        _ = NetworkAPI.makeRequest(route: .signIn, method: .post, parameters: ["idToken": idToken])
    }
    
    static func makeClass(_ courseNumber: Int, _ semester: String, _ course: String, _ courseName: String, _ professorNetids: [String], _ time: String, _ place: String) {
        _ = NetworkAPI.makeRequest(route: .makeClass, method: .post, parameters: ["courseNumber": courseNumber, "semester": semester, "course": course, "courseName": courseName, "professorNetids": professorNetids, "time": time, "place": place])
    }
    
    static func searchClasses(_ search: String) -> DataRequest {
        return NetworkAPI.makeRequest(route: .searchClasses, method: .get, parameters: ["search": search])
    }

    fileprivate static func makeRequest(route: Router, method: HTTPMethod, parameters: Parameters = [:]) -> DataRequest {
        return Alamofire.request(route, method: method, parameters: parameters)
            .validate()
            .responseJSON { response in
                //print(response)
        }
    }
}
