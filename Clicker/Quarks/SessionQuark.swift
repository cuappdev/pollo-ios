//
//  SessionQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

struct CreateSession: ClickerQuark {

    typealias ResponseType = Session
    let id: String
    let name: String
    let code: String

    var route: String {
        return "/sessions"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "id": id,
            "name": name,
            "code": code
        ]
    }
    let method: HTTPMethod = .post

    func process(element: Element) throws -> Session {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string, let isGroup = node["isGroup"].bool else {
                throw NeutronError.badResponseData
            }
            return Session(id: id, name: name, code: code, isGroup: isGroup)
        default: throw NeutronError.badResponseData
        }
    }

}

struct GetSession: ClickerQuark {

    typealias ResponseType = Session
    let id: String

    var route: String {
        return "/sessions/\(id)"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> Session {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string, let isGroup = node["isGroup"].bool else {
                throw NeutronError.badResponseData
            }
            return Session(id: id, name: name, code: code, isGroup: isGroup)
        default: throw NeutronError.badResponseData
        }
    }

}



struct GetJoinedSessions: ClickerQuark {

    typealias ResponseType = [[Session]]

    var route: String {
        return "/sessions/"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> [[Session]] {
        return []
    }

}


struct GetPollSessions: ClickerQuark {

    typealias ResponseType = [Session]
    
    let role: String

    var route: String {
        return "/sessions/all/\(role)"
    }
    var headers: HTTPHeaders {
        if let userSession = User.userSession {
            return [
                 "Authorization": "Bearer \(userSession.accessToken)"
            ]
        } else {
            return [:]
        }
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> [Session] {
        switch element {
        case .nodes(let nodes):
            var sessions: [Session] = [Session]()
            for node in nodes {
                guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string, let isGroup = node["isGroup"].bool else {
                    throw NeutronError.badResponseData
                }
                sessions.append(Session(id: id, name: name, code: code, isGroup: isGroup))
            }
            return sessions
        default:
            throw NeutronError.badResponseData
        }
    }
}

struct GetGroupSessions: ClickerQuark {
    
    typealias ResponseType = [Session]
    
    let role: String
    
    var route: String {
        return "/groups/all/\(role)"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Session] {
        switch element {
        case .nodes(let nodes):
            var sessions: [Session] = [Session]()
            for node in nodes {
                guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string, let isGroup = node["isGroup"].bool, let isLive = node["isLive"].bool else {
                    throw NeutronError.badResponseData
                }
                sessions.append(Session(id: id, name: name, code: code, isGroup: isGroup, isLive: isLive))
            }
            return sessions
        default:
            throw NeutronError.badResponseData
        }
    }
}

struct UpdateSession: ClickerQuark {

    typealias ResponseType = Session
    let id: String
    let name: String
    let code: String

    var route: String {
        return "/sessions/\(id)"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "id": id,
            "name": name,
            "code": code
        ]
    }

    let method: HTTPMethod = .put

    func process(element: Element) throws -> Session {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string, let isGroup = node["isGroup"].bool else {
                throw NeutronError.badResponseData
            }
            return Session(id: id, name: name, code: code, isGroup: isGroup)
        default: throw NeutronError.badResponseData
        }
    }
}

struct DeleteSession: ClickerQuark {

    typealias ResponseType = Void

    let id: Int

    var route: String {
        return "/sessions/\(id)"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .delete

    func process(element: Element) { }
}


struct GetMembers: ClickerQuark {
    typealias ResponseType = [User]
    let id: String

    var route: String {
        return "/sessions/\(id)/members"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> [User] {
        switch element {
        case .nodes(let nodes):
            var users: [User] = []
            for node in nodes {
                guard let id = node["id"].float, let name = node["name"].string, let netId = node["netId"].string else {
                    throw NeutronError.badResponseData
                }
                users.append(User(id: id, name: name, netId: netId))
            }
            return users
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetAdmins: ClickerQuark {
    typealias ResponseType = [User]
    let id: String

    var route: String {
        return "/sessions/\(id)/admins"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> [User] {
        switch element {
        case .nodes(let nodes):
            var users: [User] = []
            for node in nodes {
                guard let id = node["id"].float, let name = node["name"].string, let netId = node["netId"].string else {
                    throw NeutronError.badResponseData
                }
                users.append(User(id: id, name: name, netId: netId))
            }
            return users
        default: throw NeutronError.badResponseData
        }
    }
}

struct AddMembers: ClickerQuark {

    typealias ResponseType = Void
    let id: String
    let memberIds: [Int]

    var route: String {
        return "/sessions/\(id)/members"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "memberIds": memberIds
        ]
    }
    let method: HTTPMethod = .post

    func process(element: Element) throws -> Void { }
}

struct RemoveMembers: ClickerQuark {

    typealias ResponseType = Void
    let id: String
    let memberIds: [Int]

    var route: String {
        return "/sessions/\(id)/members"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "memberIds": memberIds
        ]
    }

    let method: HTTPMethod = .delete

    func process(element: Element) throws -> Void { }

}

struct AddAdmins: ClickerQuark {

    typealias ResponseType = Void
    let id: String
    let adminIds: [Int]

    var route: String {
        return "/sessions/\(id)/admins"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "adminIds": adminIds
        ]
    }
    let method: HTTPMethod = .post

    func process(element: Element) throws -> Void { }
}

struct DeleteAdmins: ClickerQuark {

    typealias ResponseType = Void
    let id: String
    let adminIds: [Int]

    var route: String {
        return "/groups/\(id)/admins"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "adminIds": adminIds
        ]
    }

    let method: HTTPMethod = .delete

    func process(element: Element) throws -> Void { }

}

struct StartSession: ClickerQuark {
    
    typealias ResponseType = Session
    let code: String
    
    var route: String {
        return "/start/session"
    }
    var headers: HTTPHeaders {
        return [
        "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
        "code" : code
        ]
    }
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> Session {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string, let isGroup = node["isGroup"].bool else {
                throw NeutronError.badResponseData
            }
            return Session(id: id, name: name, code: code, isGroup: isGroup)
        default: throw NeutronError.badResponseData
        }
    }
}
