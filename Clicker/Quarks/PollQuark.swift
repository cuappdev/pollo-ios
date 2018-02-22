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

struct GeneratePollCode : ClickerQuark {
    
    typealias ResponseType = String
    
    var route: String {
        return "/api/v1/generate/code"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> String {
        switch element {
        case .node(let node):
            print(node)
            guard let code = node["code"].string else {
                throw NeutronError.badResponseData
            }
            return code
        default: throw NeutronError.badResponseData
        }
    }
}

struct CreatePoll: ClickerQuark {
    
    typealias ResponseType = Poll
    
    let name: String
    let pollCode: String
    
    var route: String {
        return "/api/v1/polls"
    }
    var parameters: Parameters {
        return [
            "name": name,
            "code": pollCode
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let name = node["name"].string, let code = node["code"].string else {
                throw NeutronError.badResponseData
            }
            return Poll(id: id, name: name, code: code)
        default: throw NeutronError.badResponseData
        }
    }
}

struct StartCreatedPoll: ClickerQuark {
    
    typealias ResponseType = Int
    
    let id: Int
    
    var route: String {
        return "/api/v1/start/poll"
    }
    var parameters: Parameters {
        return [
            "id": id
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> Int {
        switch element {
        case .node(let node):
            guard let port = node["port"].int else {
                throw NeutronError.badResponseData
            }
            return port
        default: throw NeutronError.badResponseData
        }
    }
}

struct StartNewPoll: ClickerQuark {
    
    typealias ResponseType = Int
    
    let code: String
    let name: String
    
    var route: String {
        return "/api/v1/start/poll"
    }
    var parameters: Parameters {
        return [
            "code": code,
            "name": name
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> Int {
        switch element {
        case .node(let node):
            guard let port = node["port"].int else {
                throw NeutronError.badResponseData
            }
            return port
        default: throw NeutronError.badResponseData
        }
    }
}

struct EndPoll: ClickerQuark {
    
    typealias ResponseType = Void
    
    let id: Int
    let save: Bool
    
    var route: String {
        return "/api/v1/polls/\(id)/end"
    }
    var parameters: Parameters {
        return [
            "save": save
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> Void {
        print("saved poll")
    }
}

struct GetLivePolls: ClickerQuark {
    
    typealias ResponseType = [Poll]
    
    let pollCodes: [String]
    
    var route: String {
        return "/api/v1/polls/live"
    }
    var parameters: Parameters {
        return [
            "codes": ["ABCDEF"]
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .post
    
    func process(element: Element) throws -> [Poll] {
        switch element {
        case .nodes(let nodes):
            var polls: [Poll] = [Poll]()
            for node in nodes {
                guard let id = node["id"].int, let name = node["name"].string, let code = node["code"].string else {
                    throw NeutronError.badResponseData
                }
                polls.append(Poll(id: id, name: name, code: code))
            }
            return polls
        default:
            throw NeutronError.badResponseData
        }
    }
}

struct GetPollPorts: ClickerQuark {
    
    typealias ResponseType = Int?
    
    let id: Int
    var route: String {
        return "/api/v1/polls/\(id)/ports/"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> Int? {
        switch element {
        case .ports(let ports):
            if (ports.count == 0) {
                return nil
            } else {
                return ports[0]
            }
        default:
            throw NeutronError.badResponseData
        }
    }
}

struct UpdatePoll: ClickerQuark {
    
    typealias ResponseType = Poll
    
    let id: Int
    let name: String
    
    var route: String {
        return "/api/v1/polls/\(id)"
    }
    var parameters: Parameters {
        return [
            "name": name
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Poll {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let name = node["name"].string, let code = node["code"].string else {
                throw NeutronError.badResponseData
            }
            return Poll(id: id, name: name, code: code)
        default:
            throw NeutronError.badResponseData
        }
    }
}







