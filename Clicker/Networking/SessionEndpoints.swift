//
//  SessionEndpoints.swift
//  Clicker
//
//  Created by Matthew Coufal on 2/2/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension Endpoint {
    
    private struct CreateSessionBody: Codable {
        
        var name: String
        var code: String
        var isGroup: Bool
        
        init(name: String, code: String, isGroup: Bool) {
            self.name = name
            self.code = code
            self.isGroup = isGroup
        }
        
    }
    
    private struct UpdateSessionBody: Codable {
        
        var id: Int
        var name: String
        var code: String
        
        init(id: Int, name: String, code: String) {
            self.id = id
            self.name = name
            self.code = code
        }
        
    }
    
    static func generateCode() -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/generate/code", headers: headers)
    }
    
    static func createSession(name: String, code: String, isGroup: Bool) -> Endpoint {
        let body = CreateSessionBody(name: name, code: code, isGroup: isGroup)
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions", headers: headers, body: body)
    }
    
    static func getSession(with id: Int) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)", headers: headers)
    }
    
    static func getPollSessions(with role: UserRole) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/all/\(role)", headers: headers)
    }
    
    static func updateSessions(id: Int, name: String, code: String) -> Endpoint {
        let body = UpdateSessionBody(id: id, name: name, code: code)
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)", headers: headers, body: body)
    }
    
    static func deleteSession(with id: Int) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)", headers: headers, method: EndpointMethod.delete)
    }
    
    static func leaveSession(with id: Int) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)/members", headers: headers, method: EndpointMethod.delete)
    }
    
    static func getMembers(with id: Int) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)/members", headers: headers)
    }
    
    static func getAdmins(with id: Int) -> Endpoint {
        let headers = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")"
        ]
        return Endpoint(path: "/sessions/\(id)/admins", headers: headers)
    }
    
}
