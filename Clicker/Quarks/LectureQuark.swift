//
//  LectureQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Neutron
import SwiftyJSON
import Alamofire

struct GetLecture: ClickerQuark {
    typealias ResponseType = Lecture
    
    let id: String
    
    var route: String {
        return "/v1/lectures/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> Lecture {
        switch element {
        case .node(let node):
            guard let id = node["id"].string , let dateTime = node["dateTime"].string else {
                throw NeutronError.badResponseData
            }
            return Lecture(id, dateTime)
        default: throw NeutronError.badResponseData
        }
    }
}

struct DeleteLecture: ClickerQuark {
    typealias ResponseType = Void
    
    let id: String
    var route : String {
        return "/v1/lectures/\(id)"
    }
    let host : String = "http://localhost:3000"
    let method : HTTPMethod = .delete
    
    func process(element: Element) throws -> Void {
        return
    }
}

struct UpdateLecture : ClickerQuark {
    typealias ResponseType = Lecture
    
    let id: String
    let dateTime: String
    
    var route: String {
        return "/v1/lectures/\(id)"
    }
    var parameters: Parameters {
        return [
            "dateTime": dateTime
        ]
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .put
    
    func process(element: Element) throws -> Lecture {
        switch element {
        case.node(let node):
            guard let id = node["id"].string , let dateTime = node["dateTime"].string else {
                throw NeutronError.badResponseData
            }
            return Lecture(id, dateTime)
        default: throw NeutronError.badResponseData
        }
    }
}

// TODO: Create a question

struct GetLectureQuestions : ClickerQuark {
    typealias ResponseType = [Question]
    
    let id: String
    
    var route: String {
        return "/v1/lectures/\(id)/questions"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> [Question] {
        switch element {
        case .edges(let edges):
            let questions: [Question] = try edges.map {
                guard let id = $0.node["id"].string, let text = $0.node["text"].string, let type = $0.node["type"].string, let options = $0.node["options"].array, let answer = $0.node["answer"].string else {
                    throw NeutronError.badResponseData
                }
                let opt = options.map { json in
                    json.stringValue
                }
                return Question(id, text, type, options: opt, answer: answer)
            }
            return questions
        default: throw NeutronError.badResponseData
        }
    }
}



