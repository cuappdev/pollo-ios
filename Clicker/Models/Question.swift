//
//  Question.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit
import SwiftyJSON


class Question {
    
    var id: String
    var text: String
    var type: String // FreeResponseQuestion | MultipleChoiceQuestion | MultipleAnswerQuestion
    var options: [String]
    var answer: String?
    
    init(_ id:String, _ text: String, _ type: String, options: [String], answer: String) {
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
            json.stringValue
        })
        self.answer = json["answer"].stringValue
    }
}
