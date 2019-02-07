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
    
    private struct JoinSessionBody: Codable {
        
        var id: Int
        var code: String
        
        init(id: Int, code: String) {
            self.id = id
            self.code = code
        }
        
    }
    
    static func generateCode() -> Endpoint {
        return Endpoint(path: "/generate/code", headers: headers)
    }
    
    static func createSession(name: String, code: String, isGroup: Bool) -> Endpoint {
        let body = CreateSessionBody(name: name, code: code, isGroup: isGroup)
        return Endpoint(path: "/sessions", headers: headers, body: body)
    }
    
    static func getSession(with id: Int) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)", headers: headers)
    }
    
    static func getPollSessions(with role: UserRole) -> Endpoint {
        return Endpoint(path: "/sessions/all/\(role == .member ? "member" : "admin")", headers: headers)
    }
    
    static func updateSession(id: Int, name: String, code: String) -> Endpoint {
        let body = UpdateSessionBody(id: id, name: name, code: code)
        return Endpoint(path: "/sessions/\(id)", headers: headers, body: body)
    }
    
    static func deleteSession(with id: Int) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)", headers: headers, method: EndpointMethod.delete)
    }
    
    static func leaveSession(with id: Int) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)/members", headers: headers, method: EndpointMethod.delete)
    }
    
    static func getMembers(with id: Int) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)/members", headers: headers)
    }
    
    static func getAdmins(with id: String) -> Endpoint {
        return Endpoint(path: "/sessions/\(id)/admins", headers: headers)
    }
    
    static func addMembers(id: String, memberIds: [Int]) -> Endpoint {
        let body = [
            "memberIds": memberIds
        ]
        return Endpoint(path: "/sessions/\(id)/members", headers: headers, body: body)
    }
    
    static func removeMembers(id: String, memberIds: [Int]) -> Endpoint {
        let body = [
            "memberIds": memberIds
        ]
        return Endpoint(path: "/sessions/\(id)/members", headers: headers, body: body, method: EndpointMethod.delete)
    }
    
    static func addAdmins(id: String, adminIds: [Int]) -> Endpoint {
        let body = [
            "adminIds": adminIds
        ]
        return Endpoint(path: "/sessions/\(id)/admins", headers: headers, body: body)
    }
    
    static func deleteAdmins(id: String, adminIds: [Int]) -> Endpoint {
        let body = [
            "adminIds": adminIds
        ]
        return Endpoint(path: "/sessions/\(id)/admins", headers: headers, body: body, method: EndpointMethod.delete)
    }
    
    static func startSession(code: String, name: String?, isGroup: Bool?) -> Endpoint {
        if let name = name, let isGroup = isGroup {
            let body = CreateSessionBody(name: name, code: code, isGroup: isGroup)
            return Endpoint(path: "/start/session", headers: headers, body: body)
        }
        let modifiedHeaders = [
            "Authorization": "Bearer \(User.userSession?.accessToken ?? "")",
            "Content-Type": "application/json"
        ]
        return Endpoint(path: "/start/session", headers: modifiedHeaders, body: ["code": code])
    }
    
    static func joinSessionWithCode(with code: String) -> Endpoint {
        return Endpoint(path: "/join/session", headers: headers, body: ["code": code])
    }
    
    static func joinSessionWithId(with id: Int) -> Endpoint {
        return Endpoint(path: "/join/session", headers: headers, body: ["id": id])
    }
    
    static func joinSessionWithIdAndCode(id: Int, code: String) -> Endpoint {
        let body = JoinSessionBody(id: id, code: code)
        return Endpoint(path: "/join/session", headers: headers, body: body)
    }
    
}
