
////
////  DraftQuark.swift
////  Clicker
////
////  Created by Kevin Chan on 4/14/18.
////  Copyright © 2018 CornellAppDev. All rights reserved.
////
//
import Alamofire
import Neutron
import SwiftyJSON


struct GetDrafts: ClickerQuark {

    typealias ResponseType = [Draft]

    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var route: String {
        return "/drafts"
    }

    let method: HTTPMethod = .get

    func process(element: Element) throws -> [Draft] {
        switch element {
        case .nodes(let nodes):
            var drafts: [Draft] = []
            for node in nodes {
                guard let id = node["id"].int, let text = node["text"].string, let options = node["options"].array else {
                    throw NeutronError.badResponseData
                }
                drafts.append(Draft(id: id, text: text, options: options.map({ $0.stringValue })))
            }
            return drafts
        default: throw NeutronError.badResponseData
        }
    }

}

struct CreateDraft: ClickerQuark {

    typealias ResponseType = Draft
    let text: String
    let options: [String]

    var route: String {
        return "/drafts"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "text": text,
            "options": options
        ]
    }

    let method: HTTPMethod = .post

    func process(element: Element) throws -> Draft {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let options = node["options"].array else {
                throw NeutronError.badResponseData
            }
            return Draft(id: id, text: text, options: options.map({ $0.stringValue }))
        default: throw NeutronError.badResponseData
        }
    }
}


struct UpdateDraft: ClickerQuark {

    typealias ResponseType = Draft
    let id: String
    let text: String
    let options: [String]

    var route: String {
        return "/drafts/\(id)"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "text": text,
            "options": options
        ]
    }

    let method: HTTPMethod = .put

    func process(element: Element) throws -> Draft {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let options = node["options"].array else {
                throw NeutronError.badResponseData
            }
            return Draft(id: id, text: text, options: options.map({ $0.stringValue }))
        default: throw NeutronError.badResponseData
        }
    }
}

struct DeleteDraft: ClickerQuark {

    typealias ResponseType = Void
    let id: String
    
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var route: String {
        return "/drafts/\(id)"
    }

    let method: HTTPMethod = .delete

    func process(element: Element) throws -> Void { }

}
