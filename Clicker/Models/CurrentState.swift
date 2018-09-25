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
    var results: [String:JSON]
    var answers: [String:Any] // mapping of googleId to selectedOption
    
    init(_ pollId: Int, _ results: [String:JSON], _ answers: [String:Any]) {
        self.pollId = pollId
        self.results = results
        self.answers = answers
    }

}
