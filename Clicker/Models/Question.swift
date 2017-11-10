//
//  Question.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SwiftyJSON

class Option {
    var id: String
    var description: String
    
    init(_ id: String, _ description: String) {
        self.id = id
        self.description = description
    }
}

class Question {
    
    var id: String
    var text: String
    var type: String // FreeResponseQuestion | MultipleChoiceQuestion | MultipleAnswerQuestion
    var options: [Option]
    var answer: String?
    
    init(_ id:String, _ text: String, _ type: String, options: [Option], answer: String) {
        self.id = id
        self.text = text
        self.type = type
        self.options = options
        self.answer = answer
    }
    
    init(json: JSON){
        self.id = json["id"].stringValue
        self.text = json["text"].stringValue
        self.type = json["type"].stringValue
        self.options = json["options"].arrayValue.map({ json in
            let id = json["id"].stringValue
            let description = json["description"].stringValue
            return Option(id, description)
        })
        self.answer = json["answer"].stringValue
    }
}
