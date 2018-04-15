////
////  SessionQuark.swift
////  Clicker
////
////  Created by Kevin Chan on 4/14/18.
////  Copyright © 2018 CornellAppDev. All rights reserved.
////
//
//import Alamofire
//import Neutron
//import SwiftyJSON
//
//struct CreateSession: ClickerQuark {
//
//    typealias ResponseType = Session
//    let id: String
//    let name: String
//    let code: String
//
//    var route: String {
//        return "/sessions"
//    }
//
//    var parameters: Parameters {
//        return [
//            "id": id,
//            "name": name,
//            "code": code
//        ]
//    }
//    let method: HTTPMethod = .post
//
//    func process(element: Element) throws -> Session {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Session(id: id, name: name, code: code)
//        default: throw NeutronError.badResponseData
//        }
//    }
//
//}
//
//struct GetSession: ClickerQuark {
//
//    typealias ResponseType = Session
//    let id: String
//
//    var route: String {
//        return "/sessions/\(id)"
//    }
//    let method: HTTPMethod = .get
//
//    func process(element: Element) throws -> Session {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Session(id: id, name: name, code: code)
//        default: throw NeutronError.badResponseData
//        }
//    }
//
//}
//
//struct GetLiveSessions: ClickerQuark {
//
//    typealias ResponseType = [Session]
//
//    let pollCodes: [String]
//
//    var route: String {
//        return "/sessions/live"
//    }
//
//    var parameters: Parameters {
//        return [
//            "codes": pollCodes
//        ]
//    }
//
//    let method: HTTPMethod = .post
//    var encoding: ParameterEncoding {
//        return JSONEncoding.default
//    }
//
//    func process(element: Element) throws -> [Session] {
//        switch element {
//        case .nodes(let nodes):
//            var sessions: [Session] = [Session]()
//            for node in nodes {
//                guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                    throw NeutronError.badResponseData
//                }
//                sessions.append(Session(id: id, name: name, code: code))
//            }
//            return sessions
//        default:
//            throw NeutronError.badResponseData
//        }
//    }
//}
//
//struct UpdateSession: ClickerQuark {
//
//    typealias ResponseType = Session
//    let id: String
//    let name: String
//    let code: String
//
//    var route: String {
//        return "/sessions/\(id)"
//    }
//
//    var parameters: Parameters {
//        return [
//            "id": id,
//            "name": name,
//            "code": code
//        ]
//    }
//
//    let method: HTTPMethod = .put
//
//    func process(element: Element) throws -> Session {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Session(id: id, name: name, code: code)
//        default: throw NeutronError.badResponseData
//        }
//    }
//}
//
//struct DeleteSession: ClickerQuark {
//
//    typealias ResponseType = Void
//
//    let id: Int
//
//    var route: String {
//        return "/sessions/\(id)"
//    }
//
//    let method: HTTPMethod = .delete
//
//    func process(element: Element) { }
//}
//

//struct GetMembers: ClickerQuark {
//    typealias ResponseType = [User]
//    let id: String
//
//    var route: String {
//        return "/sessions/\(id)/members"
//    }
//
//    let method: HTTPMethod = .get
//
//    func process(element: Element) throws -> [User] {
//        switch element {
//        case .nodes(let nodes):
//            var users: [User] = []
//            for node in nodes {
//                guard let id = node["id"].int, let name = node["name"].string, let netId = node["netId"].string else {
//                    throw NeutronError.badResponseData
//                }
//                users.append(User(id: id, name: name, netId: netId))
//            }
//            return users
//        default: throw NeutronError.badResponseData
//        }
//    }
//}

//struct GetAdmins: ClickerQuark {
//    typealias ResponseType = [User]
//    let id: String
//
//    var route: String {
//        return "/sessions/\(id)/admins"
//    }
//
//    let method: HTTPMethod = .get
//
//    func process(element: Element) throws -> [User] {
//        switch element {
//        case .nodes(let nodes):
//            var users: [User] = []
//            for node in nodes {
//                guard let id = node["id"].int, let name = node["name"].string, let netId = node["netId"].string else {
//                    throw NeutronError.badResponseData
//                }
//                users.append(User(id: id, name: name, netId: netId))
//            }
//            return users
//        default: throw NeutronError.badResponseData
//        }
//    }
//}

//struct AddMembers: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//    let memberIds: [Int]
//
//    var route: String {
//        return "/sessions/\(id)/members"
//    }
//    var parameters: Parameters {
//        return [
//            "memberIds": memberIds
//        ]
//    }
//    let method: HTTPMethod = .post
//
//    func process(element: Element) throws -> Void { }
//}

//struct RemoveMembers: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//    let memberIds: [Int]
//
//    var route: String {
//        return "/sessions/\(id)/members"
//    }
//    var parameters: Parameters {
//        return [
//            "memberIds": memberIds
//        ]
//    }
//
//    let method: HTTPMethod = .delete
//
//    func process(element: Element) throws -> Void { }
//
//}

//struct AddAdmins: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//    let adminIds: [Int]
//
//    var route: String {
//        return "/sessions/\(id)/admins"
//    }
//    var parameters: Parameters {
//        return [
//            "adminIds": adminIds
//        ]
//    }
//    let method: HTTPMethod = .post
//
//    func process(element: Element) throws -> Void { }
//}

//struct DeleteAdmins: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//    let adminIds: [Int]
//
//    var route: String {
//        return "/groups/\(id)/admins"
//    }
//    var parameters: Parameters {
//        return [
//            "adminIds": adminIds
//        ]
//    }
//
//    let method: HTTPMethod = .delete
//
//    func process(element: Element) throws -> Void { }
//
//}
