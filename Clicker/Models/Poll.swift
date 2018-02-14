//
//  Poll.swift
//  Clicker
//
//  Created by Kevin Chan on 2/3/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

class Poll {
   
    var id: String
    var name: String
    var code: String
    
    init(id: String, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
}
