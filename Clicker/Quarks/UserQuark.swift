//
//  UserQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

struct GetMe: ClickerQuark {

    typealias ResponseType = User
    
    var route: String {
        return "/users"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> User {
        switch element {
        case .node(let node):
            guard let id = node["id"].rawString(), let name = node["name"].string, let netId = node["netId"].string else {
                throw NeutronError.badResponseData
            }
            return User(id: id, name: name, netId: netId)
        default: throw NeutronError.badResponseData
        }
    }
}

struct UserAuthenticate: ClickerQuark {
    typealias ResponseType = UserSession
    
    let idToken: String
    
    // CHANGE THE ROUTE TO HAVE API VERSION
    var route: String {
        return "/auth/mobile"
    }
    var parameters: Parameters {
        return [
            "idToken": idToken
        ]
    }
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> UserSession {
        switch (element) {
        case .node(let node):
            print(node)
            guard let accessToken = node["accessToken"].string, let refreshToken = node["refreshToken"].string, let sessionExpiration = node["sessionExpiration"].int, let isActive = node["isActive"].bool else {
                throw NeutronError.badResponseData
            }
            print("succeeded parsing /auth/mobile response")
            return UserSession(accessToken: accessToken, refreshToken: refreshToken, sessionExpiration: sessionExpiration, isActive: isActive)
        default:
            throw NeutronError.badResponseData
        }
    }
}

struct UserRefreshSession: ClickerQuark {
    typealias ResponseType = UserSession
    
    var route: String {
        return "/auth/refresh"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> UserSession {
        switch (element) {
        case .node(let node):
            guard let accessToken = node["accessToken"].string, let refreshToken = node["refreshToken"].string, let sessionExpiration = node["sessionExpiration"].int, let isActive = node["isActive"].bool else {
                throw NeutronError.badResponseData
            }
            print("succeeded parsing /auth/mobile response")
            return UserSession(accessToken: accessToken, refreshToken: refreshToken, sessionExpiration: sessionExpiration, isActive: isActive)
        default:
            throw NeutronError.badResponseData
        }
    }
}
