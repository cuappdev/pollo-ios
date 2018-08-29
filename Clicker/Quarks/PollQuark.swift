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
    let method: HTTPMethod = .post

    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject, let type = node["type"].string, let shared = node["shared"].bool else {
                throw NeutronError.badResponseData
            }
            let questionType: QuestionType = (type == Identifiers.multipleChoice) ? .multipleChoice : .freeResponse
            return Poll(id: id, text: text, results: results, type: questionType, isShared: shared)
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
            guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject, let type = node["type"].string, let shared = node["shared"].bool else {
                throw NeutronError.badResponseData
            }
            let questionType: QuestionType = (type == Identifiers.multipleChoice) ? .multipleChoice : .freeResponse
            return Poll(id: id, text: text, results: results, type: questionType, isShared: shared)
        default: throw NeutronError.badResponseData
        }
    }
}

struct GetSortedPolls: ClickerQuark {
    typealias ResponseType = [(String, [Poll])]
    
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
    
    func process(element: Element) throws -> [(String, [Poll])] {
        switch element {
        case .node(let node):
            var datePollsDict: [String:[Poll]] = [:]
            for (date, pollsJSON) in node {
                if let pollsArray = pollsJSON.array {
                    let pollsArr: [Poll] = try pollsArray.map {
                        guard let id = $0["id"].int, let text = $0["text"].string, let results = $0["results"].dictionaryObject, let type = $0["type"].string, let shared = $0["shared"].bool else {
                            throw NeutronError.badResponseData
                        }
                        let questionType: QuestionType = (type == Identifiers.multipleChoice) ? .multipleChoice : .freeResponse
                        return Poll(id: id, text: text, results: results, type: questionType, isShared: shared)
                    }
                    datePollsDict[date] = pollsArr
                }
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            return datePollsDict.map { (formatter.date(from: $0)!, $0, $1) }
                .sorted() { ($0.0 as Date).compare($1.0 as Date) == .orderedAscending }
                .map() { (_, dateString, dayTotal) in (dateString, dayTotal) }
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
            var polls: [Poll] = []
            for node in nodes {
                guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject, let type = node["type"].string, let shared = node["shared"].bool else {
                    throw NeutronError.badResponseData
                }
                let questionType: QuestionType = (type == Identifiers.multipleChoice) ? .multipleChoice : .freeResponse
                polls.append(Poll(id: id, text: text, results: results, type: questionType, isShared: shared))
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
            guard let id = node["id"].int, let text = node["text"].string, let results = node["results"].dictionaryObject, let type = node["type"].string, let shared = node["shared"].bool else {
                throw NeutronError.badResponseData
            }
            let questionType: QuestionType = (type == Identifiers.multipleChoice) ? .multipleChoice : .freeResponse
            return Poll(id: id, text: text, results: results, type: questionType, isShared: shared)
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
