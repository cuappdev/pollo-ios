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
    let sessionId: Int
    let text: String
    let results: [String:Any]
    let type: QuestionType
    let isShared: Bool

    var route: String {
        return "/sessions/\(sessionId)/polls"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    var parameters: Parameters {
        return [
            "text": text,
            "results": results,
            "type": type.descriptionForServer,
            "shared": isShared
        ]
    }
    let method: HTTPMethod = .post

    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            return PollParser.parseItem(json: node)
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
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            return PollParser.parseItem(json: node)
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetSortedPolls: ClickerQuark {
    typealias ResponseType = [PollsDateModel]
    
    let id: Int
    
    var route: String {
        return "/sessions/\(id)/polls/date"
    }
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [PollsDateModel] {
        switch element {
        case .node(let node):
            var pollsDateArray: [PollsDateModel] = []
            for (date, pollsJSON) in node {
                if let pollsArray = pollsJSON.array {
                    let pollsArr: [Poll] = try pollsArray.map {
                        return PollParser.parseItem(json: $0)
                    }
                    let pollsDateModel = PollsDateModel(date: date, polls: pollsArr)
                    pollsDateArray.append(pollsDateModel)
                }
            }
            return pollsDateArray
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
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .get

    func process(element: Element) throws -> [Poll] {
        switch element {
        case .nodes(let nodes):
            return nodes.map {
                return PollParser.parseItem(json: $0)
            }
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
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
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
            return PollParser.parseItem(json: node)
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
    var headers: HTTPHeaders {
        return [
            "Authorization": "Bearer \(User.userSession!.accessToken)"
        ]
    }
    let method: HTTPMethod = .delete

    func process(element: Element) { }
}
