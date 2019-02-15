//
//  CurrentState.swift
//  Clicker
//
//  Created by Kevin Chan on 2/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import SwiftyJSON

class CurrentState {
    
    var pollId: Int
    var results: [String: JSON] // MC: {'A': {'text': 'blue', 'count': 1}}, FR: {1: {'text': 'blue', 'count': 1}}
    var answers: [String: Any] // mapping of client id to answer choice for MC and array of answer ids for FR
    var upvotes: [String: [String]] // mapping of client id to array of answer ids

    init(_ pollId: Int, _ results: [String: JSON], _ answers: [String: Any], _ upvotes: [String: [String]]) {
        self.pollId = pollId
        self.results = results
        self.answers = answers
        self.upvotes = upvotes
    }

}
