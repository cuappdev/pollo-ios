//
//  Question.swift
//  Clicker
//
//  Created by Kevin Chan on 10/14/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class Question {
    
    var id: String
    var text: String
    var type: String
    var data: String
    
    init(_ id:String, _ text: String, _ type: String, _ data: String) {
        self.id = id
        self.text = text
        self.type = type
        self.data = data
    }
}