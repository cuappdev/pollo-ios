//
//  Answer.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

class Answer {
    
    var id: Int
    var deviceId: Int
    var questionId: Int
    var choice: String!
    var text: String!

    init(_ id: Int, _ deviceId: Int, _ questionId: Int, _ choice: String, _ text: String) {
        self.id = id
        self.deviceId = deviceId
        self.questionId = questionId
        self.choice = choice
        self.text = text
    }
}
