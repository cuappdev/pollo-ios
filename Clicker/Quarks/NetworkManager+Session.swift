//
//  NetworkManager+Session.swift
//  Clicker
//
//  Created by Matthew Coufal on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension NetworkManager {
    
    struct GetPollSessionsRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .get
    }
    
    class func getPollSessions(role: UserRole, completion: @escaping ((Result<[Session]>) -> Void)) {
        let route = "/sessions/all/\(role)"
        let apiRequest = GetPollSessionsRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct GenerateCodeRequest: APIRequest {
        let route: String = "/generate/code"
        let method: HTTPMethod = .get
    }
    
    class func generateCode(completion: @escaping ((Result<String>) -> Void)) {
        performRequest(for: GenerateCodeRequest(), completion: completion)
    }
    
    struct CreateSessionRequest: APIRequest {
        let route: String = "/sessions"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func createSession(name: String, code: String, isGroup: Bool, completion: @escaping ((Result<Session>) -> Void)) {
        let parameters: Parameters = ["name": name, "code": code, "isGroup": isGroup]
        let apiRequest = CreateSessionRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct GetSessionRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .get
    }
    
    class func getSession(id: String, completion: @escaping ((Result<Session>) -> Void)) {
        let route: String = "/sessions/\(id)"
        let apiRequest = GetSessionRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct UpdateSessionRequest: APIRequest {
        let route: String
        let parameters: Parameters
        let method: HTTPMethod = .put
    }
    
    class func updateSession(id: Int, name: String, code: String, completion: @escaping ((Result<Session>) -> Void)) {
        let route: String = "/sessions/\(id)"
        let parameters: Parameters = ["id": id, "name": name, "code": code]
        let apiRequest = UpdateSessionRequest(route: route, parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct DeleteSessionRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .delete
    }
    
    class func deleteSession(id: Int, completion: @escaping ((Result<NoResponse>) -> Void)) {
        let route: String = "/sessions/\(id)"
        let apiRequest = DeleteSessionRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct LeaveSessionRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .delete
    }
    
    class func leaveSession(id: Int, completion: @escaping ((Result<NoResponse>) -> Void)) {
        let route: String = "/sessions/\(id)/members"
        let apiRequest = LeaveSessionRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct GetMembersRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .get
    }
    
    class func getMembers(id: String, completion: @escaping ((Result<[User]>) -> Void)) {
        let route: String = "/sessions/\(id)/members"
        let apiRequest = GetMembersRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct GetAdminsRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .get
    }
    
    class func getAdmins(id: String, completion: @escaping ((Result<[User]>) -> Void)) {
        let route: String = "/sessions/\(id)/admins"
        let apiRequest = GetAdminsRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct AddMembersRequest: APIRequest {
        let route: String
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func addMembers(id: String, memberIds: [Int], completion: @escaping ((Result<NoResponse>) -> Void)) {
        let route: String = "/sessions/\(id)/members"
        let parameters: Parameters = ["memberIds": memberIds]
        let apiRequest = AddMembersRequest(route: route, parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct RemoveMembersRequest: APIRequest {
        let route: String
        let parameters: Parameters
        let method: HTTPMethod = .delete
    }
    
    class func removeMembers(id: String, memberIds: [Int], completion: @escaping ((Result<NoResponse>) -> Void)) {
        let route: String = "/sessions/\(id)/members"
        let parameters: Parameters = ["memberIds": memberIds]
        let apiRequest = RemoveMembersRequest(route: route, parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct AddAdminsRequest: APIRequest {
        let route: String
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func addAdmins(id: String, adminIds: [Int], completion: @escaping ((Result<NoResponse>) -> Void)) {
        let route: String = "/sessions/\(id)/admins"
        let parameters: Parameters = ["adminIds": adminIds]
        let apiRequest = AddAdminsRequest(route: route, parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct DeleteAdminsRequest: APIRequest {
        let route: String
        let parameters: Parameters
        let method: HTTPMethod = .delete
    }
    
    class func deleteAdmins(id: String, adminIds: [Int], completion: @escaping ((Result<NoResponse>) -> Void)) {
        let route: String = "/sessions/\(id)/admins"
        let parameters: Parameters = ["adminIds": adminIds]
        let apiRequest = DeleteAdminsRequest(route: route, parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct StartSessionRequest: APIRequest {
        let route: String = "/start/session"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func startSession(code: String, name: String?, isGroup: Bool?, completion: @escaping ((Result<Session>) -> Void)) {
        var parameters: Parameters = [:]
        if let name = name, let isGroup = isGroup {
            parameters = ["code": code, "name": name, "isGroup": isGroup]
        } else {
            parameters = ["code": code]
        }
        let apiRequest = StartSessionRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct JoinSessionWithCodeRequest: APIRequest {
        let route: String = "/join/session"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func joinSessionWithCode(code: String, completion: @escaping ((Result<Session>) -> Void)) {
        let parameters: Parameters = ["code": code]
        let apiRequest = JoinSessionWithCodeRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct JoinSessionWithIdRequest: APIRequest {
        let route: String = "/join/session"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func joinSessionWithId(id: Int, completion: @escaping ((Result<Session>) -> Void)) {
        let parameters: Parameters = ["id": id]
        let apiRequest = JoinSessionWithIdRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct JoinSessionWithIdAndCodeRequest: APIRequest {
        let route: String = "/join/session"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func joinSessionWithIdAndCode(id: Int, code: String, completion: @escaping ((Result<Session>) -> Void)) {
        let parameters: Parameters = ["id": id, "code": code]
        let apiRequest = JoinSessionWithIdAndCodeRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
}
