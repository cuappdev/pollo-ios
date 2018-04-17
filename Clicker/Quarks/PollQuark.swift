//
//  PollQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 2/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//
import Alamofire
import Neutron
import SwiftyJSON

struct CreatePoll: ClickerQuark {

    typealias ResponseType = Poll
    let id: Int
    let text: String
    let results: [String:Any]

    var route: String {
        return "/sessions/\(id)/polls"
    }

    var parameters: Parameters {
        return [
            "text": text,
            "results": results
        ]
    }
    let method: HTTPMethod = .post
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject else {
                throw NeutronError.badResponseData
            }
            return Poll(id: id, text: text, results: results)
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetPoll: ClickerQuark {

    typealias ResponseType = Poll
    let id: Int

    var route: String {
        return "/polls/\(id)"
    }

    let method: HTTPMethod = .get

    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject else {
                throw NeutronError.badResponseData
            }
            return Poll(id: id, text: text, results: results)
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetSortedPolls: ClickerQuark {
    typealias ResponseType = [Poll]
    
    let id: String
    
    var route: String {
        return "/sessions/\(id)/polls"
    }
    
    let method: HTTPMethod = .get
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    func process(element: Element) throws -> [Poll] {
        switch element {
        case .node(let node):
            var polls: [Poll] = [Poll]()
            for (date, pollsArr) in node {
                for poll in pollsArr {
                    guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject else {
                        throw NeutronError.badResponseData
                    }
                    let p = Poll(id: id, text: text, results: results)
                    p.date = date
                    polls.append(p)
                }
            }
            return polls
        default:
            throw NeutronError.badResponseData
        }
    }
}

struct GetPollsForSession: ClickerQuark {

    typealias ResponseType = [Poll]
    let id: Int

    var route: String {
        return "/sessions/\(id)/polls"
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> [Poll] {
        switch element {
        case .nodes(let nodes):
            var polls: [Poll] = []
            for node in nodes {
                guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject else {
                    throw NeutronError.badResponseData
                }
                polls.append(Poll(id: id, text: text, results: results))
            }
            return polls
        default: throw NeutronError.badResponseData
        }
    }
}


struct UpdatePoll: ClickerQuark {

    typealias ResponseType = Poll
    let id: Int
    let text: String
    let results: [String:Any]

    var route: String {
        return "/polls/\(id)"
    }

    var parameters: Parameters {
        return [
            "text": text,
            "results": results
        ]
    }
    let method: HTTPMethod = .put

    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject else {
                throw NeutronError.badResponseData
            }
            return Poll(id: id, text: text, results: results)
        default: throw NeutronError.badResponseData
        }
    }
}

struct DeletePoll: ClickerQuark {

    typealias ResponseType = Void
    let id: Int

    var route: String {
        return "/polls/\(id)"
    }

    let method: HTTPMethod = .delete

    func process(element: Element) { }
}
