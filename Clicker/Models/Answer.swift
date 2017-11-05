//
//  Answer.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class Answer {
    
    var id: String
    var question: String
    var answerer: String
    var type: String  // SingleResponse | MultipleResponse
    var response: [String]
    
    init(_ id: String, _ question: String, _ answerer: String, _ type: String, _ response: [String]) {
        self.id = id
        self.question = question
        self.answerer = answerer
        self.type = type
        self.response = response
    }
    
}
