////
////  GroupQuark.swift
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
//struct CreateGroup: ClickerQuark {
//
//    typealias ResponseType = Group
//    let name: String
//    let code: String
//    let memberIds: [Int]
//    let sessionId: Int
//
//    var route: String {
//        return "/groups"
//    }
//
//    var parameters: Parameters {
//        return [
//            "name": name,
//            "code": code,
//            "memberIds": memberIds,
//            "sessionId": sessionId
//        ]
//    }
//    let method: HTTPMethod = .post
//
//    func process(element: Element) throws -> Group {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Group(id: id, name: name, code: code)
//        default: throw NeutronError.badResponseData
//        }
//    }
//
//}
//
//struct GetGroup: ClickerQuark {
//
//    typealias ResponseType = Group
//    let id: String
//
//    var route: String {
//        return "/groups/\(id)"
//    }
//    let method: HTTPMethod = .get
//
//    func process(element: Element) throws -> Group {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Group(id: id, name: name, code: code)
//        default: throw NeutronError.badResponseData
//        }
//    }
//
//}
//
//struct UpdateGroup: ClickerQuark {
//
//    typealias ResponseType = Group
//    let id: String
//    let name: String
//
//    var route: String {
//        return "/groups/\(id)"
//    }
//
//    var parameters: Parameters {
//        return [
//            "id": id,
//            "name": name
//        ]
//    }
//    let method: HTTPMethod = .put
//
//    func process(element: Element) throws -> Group {
//        switch element {
//        case .node(let node):
//            guard let id = node["id"].string, let name = node["name"].string, let code = node["code"].string else {
//                throw NeutronError.badResponseData
//            }
//            return Group(id: id, name: name, code: code)
//        default: throw NeutronError.badResponseData
//        }
//    }
//
//}
//
//struct DeleteGroup: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//
//    var route: String {
//        return "/groups/\(id)"
//    }
//
//    let method: HTTPMethod = .delete
//
//    func process(element: Element) throws -> Void { }
//
//}
//
//// TODO: GetGroupMembers, GetGroupAdmins
//
//struct AddGroupMembers: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//    let memberIds: [Int]
//
//    var route: String {
//        return "/groups/\(id)/members"
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
//
//struct AddGroupAdmins: ClickerQuark {
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
//    let method: HTTPMethod = .post
//
//    func process(element: Element) throws -> Void { }
//}
//
//struct DeleteGroupMembers: ClickerQuark {
//
//    typealias ResponseType = Void
//    let id: String
//    let memberIds: [Int]
//
//    var route: String {
//        return "/groups/\(id)/members"
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
//
//struct DeleteGroupAdmins: ClickerQuark {
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
//
//
