//
//  User.swift
//  Clicker
//
//  Created by Kevin Chan on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

enum UserRole: String {
    case admin
    case member = "user"
}

class User: Codable {
    
    static var currentUser: User?
    static var userSession: UserSession?
    
    var id: String
    var name: String
    var netId: String
    var givenName: String?
    var familyName: String?
    var email: String?
    
    init(id: String, name: String, netId: String) {
        self.id = id
        self.name = name
        self.netId = netId
    }
    
    init(id: String, name: String, netId: String, givenName: String, familyName: String, email: String) {
        self.id = id
        self.name = name
        self.netId = netId
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
    }
    
}

struct UserSession: Codable {
    
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
