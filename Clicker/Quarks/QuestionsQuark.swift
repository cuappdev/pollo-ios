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

struct GetQuestion: JSONQuark {
    typealias ResponseType = Question
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> Question {
        guard let id = response["node"]["id"].string, let text = response["node"]["text"].string, let type = response["node"]["type"].string, let data = response["node"]["data"].string else {
            throw NeutronError.badResponseData
        }
        return Question(id, text, type, data)
    }
}

struct UpdateQuestion: JSONQuark {
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
    
    func process(response: JSON) throws -> Question {
        guard let id = response["node"]["id"].string, let text = response["node"]["text"].string, let type = response["node"]["type"].string, let data = response["node"]["data"].string else {
            throw NeutronError.badResponseData
        }
        return Question(id, text, type, data)
    }
}

struct DeleteQuestion: JSONQuark {
    typealias ResponseType = Void
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .delete
    
    func process(response: JSON) throws -> Void {
        return
    }
}

struct GetAnswersToQuestion: JSONQuark {
    typealias ResponseType = [Answer]
    
    let id: String
    
    var route: String {
        return "/v1/question/\(id)/answers"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> [Answer] {
        guard let answersArray = response["edges"].array else {
            throw NeutronError.badResponseData
        }
        
        if answersArray.count == 0 {
            return [Answer]()
        }
        
        let answers: [Answer]? = try answersArray.map { json -> Answer in
            guard let id = json["node"]["id"].string, let question = json["node"]["question"].string, let answerer = json["node"]["answerer"].string, let type = json["node"]["type"].string, let data = json["node"]["data"].string else {
                throw NeutronError.badResponseData
            }
            return Answer(id, question, answerer, type, data)
        }
        if let a = answers {
            return a
        } else {
            throw NeutronError.badResponseData
        }
    }
}

struct AnswerQuestion: JSONQuark {
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
    
    func process(response: JSON) throws -> Answer {
        guard let id = response["node"]["id"].string, let question = response["node"]["question"].string, let answerer = response["node"]["answerer"].string, let type = response["node"]["type"].string, let data = response["node"]["data"].string else {
            throw NeutronError.badResponseData
        }
        return Answer(id, question, answerer, type, data)
    }
}
