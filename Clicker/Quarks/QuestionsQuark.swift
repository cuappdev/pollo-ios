//
//  QuestionsQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Neutron
import SwiftyJSON
import Alamofire

struct GetQuestion: ClickerQuark {
    typealias ResponseType = Question
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> Question {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let text = node["text"].string, let type = node["type"].string, let data = node["data"].string else {
                throw NeutronError.badResponseData
            }
            return Question(id, text, type, data)
        default: throw NeutronError.badResponseData
        }
    }
}

struct UpdateQuestion: ClickerQuark {
    typealias ResponseType = Question
    
    let id: String
    let text: String
    let data: String
    
    var route: String {
        return "/v1/question/\(id)"
    }
    var parameters: Parameters {
        return [
            "text": text,
            "data": data
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Question {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let text = node["text"].string, let type = node["type"].string, let data = node["data"].string else {
                throw NeutronError.badResponseData
            }
            return Question(id, text, type, data)
        default: throw NeutronError.badResponseData
        }
    }
}

struct DeleteQuestion: ClickerQuark {
    typealias ResponseType = Void
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .delete
    
    func process(element: Element) throws -> Void {
        return
    }
}

struct GetAnswersToQuestion: ClickerQuark {
    typealias ResponseType = [Answer]
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)/answers"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Answer] {
        switch element {
        case .edges(let edges):
            let answers: [Answer] = try edges.map {
                guard let id = $0.node["id"].string, let question = $0.node["question"].string, let answerer = $0.node["answerer"].string, let type = $0.node["type"].string, let data = $0.node["data"].string else {
                    throw NeutronError.badResponseData
                }
                return Answer(id, question, answerer, type, data)
            }
            return answers
        default: throw NeutronError.badResponseData
        }
    }
}

struct AnswerQuestion: ClickerQuark {
    typealias ResponseType = Answer
    
    let id: String
    let answer: String
    
    var route: String {
        return "/v1/question/\(id)/answer"
    }
    var parameters: Parameters {
        return [
            "answer": answer
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Answer {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let question = node["question"].string, let answerer = node["answerer"].string, let type = node["type"].string, let data = node["data"].string else {
                throw NeutronError.badResponseData
            }
            return Answer(id, question, answerer, type, data)
        default: throw NeutronError.badResponseData
        }
    }
}
