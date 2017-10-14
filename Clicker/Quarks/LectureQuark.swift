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

struct GetLecture: JSONQuark {
    typealias ResponseType = Lecture
    
    let id: String
    
    var route: String {
        return "/v1/lectures/\(id)"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> Lecture {
        guard let id = response["node"]["id"].string , let dateTime = response["node"]["dateTime"].string else {
            throw NeutronError.badResponseData
        }
        return Lecture(id, dateTime)
    }
}

struct DeleteLecture: JSONQuark {
    typealias ResponseType = Void
    
    let id: String
    var route : String {
        return "/v1/lectures/\(id)"
    }
    let host : String = "http://localhost:3000"
    let method : HTTPMethod = .delete
    
    func process(response: JSON) throws -> Void {
        return
    }
}

struct UpdateLecture : JSONQuark {
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
    
    func process(response: JSON) throws -> Lecture {
        guard let id = response["node"]["id"].string , let dateTime = response["node"]["dateTime"].string else {
            throw NeutronError.badResponseData
        }
        return Lecture(id, dateTime)
    }
}

// TODO: Create a question

struct GetLectureQuestions : JSONQuark {
    typealias ResponseType = [Question]
    
    let id: String
    
    var route: String {
        return "/v1/lectures/\(id)/questions"
    }
    let host: String = "http://localhost:3000"
    let method: HTTPMethod = .get
    
    func process(response: JSON) throws -> [Question] {
        guard let questionsArray = response["edges"].array else {
            throw NeutronError.badResponseData
        }
        
        if questionsArray.count == 0 {
            return [Question]()
        }
        
        let questions: [Question]? = try questionsArray.map { json -> Question in
            guard let id = json["node"]["id"].string, let text = json["node"]["text"].string, let type = json["node"]["type"].string, let data = json["node"]["data"].string else {
                throw NeutronError.badResponseData
            }
            return Question(id, text, type, data)
        }
        if let q = questions {
            return q
        } else {
            throw NeutronError.badResponseData
        }
    }
}

