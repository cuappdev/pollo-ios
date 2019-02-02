//
//  SessionEndpoints.swift
//  Clicker
//
//  Created by Matthew Coufal on 2/2/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension Endpoint {
    
    private struct SessionBody: Codable {
        
        var name: String
        var code: String
        var isGroup: Bool
        
        init(name: String, code: String, isGroup: Bool) {
            self.name = name
            self.code = code
            self.isGroup = isGroup
        }
        
    }
    
    static func generateCode() -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/generate/code", headers: headers)
    }
    
    static func createSession(name: String, code: String, isGroup: Bool) -> Endpoint {
        let body = SessionBody(name: name, code: code, isGroup: isGroup)
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions", headers: headers, body: body)
    }
    
}
