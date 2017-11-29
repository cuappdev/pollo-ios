//
//  User.swift
//  Clicker
//
//  Created by Kevin Chan on 9/26/17.
//  Copyright © 2017 CornellAppDev. All rights reserved.
//

import UIKit

class User : NSObject {
    
    static var currentUser: User?
    
    var id: String
    var netID: String
    var name: String
    
    init(id: String, netID: String, name: String) {
        self.id = id
        self.netID = netID
        self.name = name
    }
    
}
