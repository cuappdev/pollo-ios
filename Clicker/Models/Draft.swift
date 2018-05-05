//
//  Draft.swift
//  Clicker
//
//  Created by Kevin Chan on 4/14/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

class Draft {
    
    var id: Int
    var text: String
    var options: [String]
    
    init(id: Int, text: String, options: [String]) {
        self.id = id
        self.text = text
        self.options = options
    }
    
}
