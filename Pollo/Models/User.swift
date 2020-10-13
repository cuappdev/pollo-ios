//
//  User.swift
//  Pollo
//
//  Created by Kevin Chan on 4/15/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation

enum UserRole: String {
    case admin
    case member = "user"
}

struct GetMemberResponse: Codable {

    var id: String
    var name: String
    var netID: String

}

class User: Codable {

    static var currentUser: User?
    static var userSession: UserSession?

    var id: String
    var name: String
    var netId: String

    init(id: String, name: String, netId: String) {
        self.id = id
        self.name = name
        self.netId = netId
    }

}

struct UserSession: Codable {

    let accessToken: String
    let isActive: Bool
    let refreshToken: String
    let sessionExpiration: String

    init(accessToken: String, refreshToken: String, sessionExpiration: String, isActive: Bool) {
        self.accessToken = accessToken
        self.isActive = isActive
        self.refreshToken = refreshToken
        self.sessionExpiration = sessionExpiration
    }

}
