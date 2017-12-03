//
//  QuestionsQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

struct GetQuestion: ClickerQuark {
    typealias ResponseType = Question
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)"
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> Question {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let text = node["text"].string, let type = node["type"].string, let options = node["options"].array, let answer = node["answer"].string else {
                throw NeutronError.badResponseData
            }
            let opt = options.map { json -> Option in
                let id = json["id"].stringValue
                let description = json["description"].stringValue
                return Option(id, description)
            }
            return Question(id, text, type, options: opt, answer: answer)
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
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Question {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let text = node["text"].string, let type = node["type"].string,
            let options = node["options"].array, let answer = node["answer"].string else {
                throw NeutronError.badResponseData
            }
            let opt = options.map { json -> Option in 
                let id = json["id"].stringValue
                let description = json["description"].stringValue
                return Option(id, description)
            }
            return Question(id, text, type, options: opt, answer: answer)
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
    let host: String = "http://localhost:3000/api"
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
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Answer] {
        switch element {
        case .edges(let edges):
            let answers: [Answer] = try edges.map {
                guard let id = $0.node["id"].string, let question = $0.node["question"].string, let answerer = $0.node["answerer"].string, let type = $0.node["type"].string else {
                    throw NeutronError.badResponseData
                }
                let response = $0.node["response"]
                switch type {
                    case "MultipleResponse":
                        let jsonArr = response.arrayValue
                        let responseArr = jsonArr.map { json in
                                json.stringValue
                        }
                        return Answer(id, question, answerer, type, responseArr)
                    default:
                        let res = response.stringValue
                        return Answer(id, question, answerer, type, [res])
                }
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
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Answer {
        switch element {
        case .node(let node):
            guard let id = node["id"].string, let question = node["question"].string, let answerer = node["answerer"].string, let type = node["type"].string else {
                throw NeutronError.badResponseData
            }
            let response = node["response"]
            switch type {
            case "MultipleResponse":
                let jsonArr = response.arrayValue
                let responseArr = jsonArr.map { json in
                    json.stringValue
                }
                return Answer(id, question, answerer, type, responseArr)
            default:
                let res = response.stringValue
                return Answer(id, question, answerer, type, [res])
            }
        default: throw NeutronError.badResponseData
        }
    }
}
