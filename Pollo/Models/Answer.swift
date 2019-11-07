//
//  Answer.swift
//  Pollo
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

class Answer {

    var choice: String
    var id: String?
    var pollId: String
    var text: String

    init(text: String, choice: String, pollId: String) {
        self.choice = choice
        self.pollId = pollId
        self.text = text
    }

}
