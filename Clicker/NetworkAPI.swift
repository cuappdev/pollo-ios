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
    static let baseURL = "http://10.148.4.89:8080"
    
    case signIn
    
    func asURL() throws -> URL {
        let route: String = {
            switch self {
            case .signIn: return "/auth/signin"
            }
        }()
        
        return URL(string: Router.baseURL + route)!
    }
}


class NetworkAPI {
    
    static func login(_ idToken: String) {
        NetworkAPI.makeRequest(route: .signIn, method: .post, parameters: ["idToken": idToken])
    }
    
    fileprivate static func makeRequest(route: Router, method: HTTPMethod, parameters: Parameters = [:]) {
        
        Alamofire.request(route, method: method, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response)
        }
    }
}
