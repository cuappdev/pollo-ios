//
//  Answer.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

class Answer {
    
    var id: Int?
    var text: String
    var choice: String
    var pollId: Int

    init(text: String, choice: String, pollId: Int) {
        self.text = text
        self.choice = choice
        self.pollId = pollId
    }
    
}
