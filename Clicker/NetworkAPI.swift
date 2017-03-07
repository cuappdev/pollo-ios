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
    static let baseURL = "http://localhost"
    case login,users
    
    func asURL() throws -> URL {
        let ext: String = {
            switch self {
            case .login: return "/login"
            case .users: return "/users"
            }
        }()
        
        return URL(string: Router.baseURL + ext)!
    }
}


class NetworkAPI {
    
    static func login(_ idToken: String) {
        NetworkAPI.makeRequest(route: Router.login, method: .post, parameters: ["idToken": idToken])
    }
    
    fileprivate static func makeRequest(route: URLConvertible, method: HTTPMethod, parameters: Parameters?) {
        var parameters = parameters ?? [:]
        if let sessionHash = UserDefaults.standard.string(forKey: "Auth") {
            parameters["Auth"] = sessionHash
        }
        
        Alamofire.request(route, method: method, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response)
        }
    }
}
