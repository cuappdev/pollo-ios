//
//  Session.swift
//  Clicker
//
//  Created by Kevin Chan on 10/30/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import Foundation

class Session {
    
    var id: String
    var name: String
    var code: String
    var isGroup: Bool
    
    init(id: String, name: String, code: String, isGroup: Bool) {
        self.id = id
        self.name = name
        self.code = code
        self.isGroup = isGroup
    }
    
}
