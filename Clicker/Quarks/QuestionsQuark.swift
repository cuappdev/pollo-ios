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

struct GetQuestionAtPort: ClickerQuark {
    typealias ResponseType = Question

    let port: Int

    var route: String {
        return "/v1/polls/question/\(port)"
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get

    func process(element: Element) throws -> Question {
        switch element {
        case .node(let node):
            guard let id = node["id"].int, let text = node["text"].string, let type = node["type"].string, let options = node["options"].array else {
                throw NeutronError.badResponseData
            }
            let opt = options.map {
                $0.stringValue
            }
            return Question(id, text, type, options: opt)
        default: throw NeutronError.badResponseData
        }
    }
}


