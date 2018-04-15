//
//  User.swift
//  Clicker
//
//  Created by Kevin Chan on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

class User {
    
    static var userSession: UserSession?
    
    var id: Int
    var name: String
    var netId: String
    
    init(id: Int, name: String, netId: String) {
        self.id = id
        self.name = name
        self.netId = netId
    }
    
}

struct UserSession {
    
    let accessToken: String
    let refreshToken: String
    let sessionExpiration: Int
    let isActive: Bool
    
    init(accessToken: String, refreshToken: String, sessionExpiration: Int, isActive: Bool) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.sessionExpiration = sessionExpiration
        self.isActive = isActive
    }
    
}
