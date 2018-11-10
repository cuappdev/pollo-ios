//
//  DraftQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
//
import Alamofire
import Neutron
import SwiftyJSON


struct GetDrafts: ClickerQuark {

    typealias ResponseType = [Draft]

    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }
    var route: String {
        return "/drafts"
    }

    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Draft] {
        switch element {
        case .edges(let edges):
            var drafts: [Draft] = []
            for edge in edges {
                let node = edge.node
                if let id = node["id"].int, let text = node["text"].string, let options = node["options"].array {
                    let draft = Draft(id: id, text: text, options: options.map({ $0.stringValue }))
                    drafts.insert(draft, at: 0)
                } else {
                    throw NeutronError.badResponseData
                }
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
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var parameters: Parameters {
        return [
            "text": text,
            "options": options
        ]
    }

    let method: HTTPMethod = .post

    func process(element: Element) throws -> Draft {
        print("options: ", options)
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let options = node["options"].array else {
                throw NeutronError.badResponseData
            }
            print("options: ", options)
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
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }
    var encoding: ParameterEncoding {
        return JSONEncoding.default
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
    let id: Int
    
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
    }
    var route: String {
        return "/drafts/\(id)"
    }

    let method: HTTPMethod = .delete

    func process(element: Element) throws -> Void { }

}
