//
//  CurrentState.swift
//  Clicker
//
//  Created by Kevin Chan on 2/17/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class CurrentState {
    
    var question: Int
    var results: [String:Any]
    var answers: [String:Any]
    
    init(_ question: Int, _ results: [String:Any], _ answers: [String:Any]) {
        self.question = question
        self.results = results
        self.answers = answers
    }
    
}
