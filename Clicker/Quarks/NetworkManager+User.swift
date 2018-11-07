//
//  NetworkManager+User.swift
//  Clicker
//
//  Created by Matthew Coufal on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension NetworkManager {
    
    struct GetMeRequest: APIRequest {
        let route: String = "/users"
        let method: HTTPMethod = .get
    }
    
    class func getMe(completion: @escaping ((Result<User>) -> Void)) {
        performRequest(for: GetMeRequest(), completion: completion)
    }
    
    struct UserAuthenticateRequest: APIRequest {
        let route: String = "/auth/mobile"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func userAuthenticate(idToken: String, completion: @escaping ((Result<UserSession>) -> Void)) {
        let parameters: Parameters = ["idToken": idToken]
        let apiRequest = UserAuthenticateRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct UserRefreshSessionRequest: APIRequest {
        let route: String = "/auth/refresh"
        let method: HTTPMethod = .get
    }
    
    class func userRefreshSession(completion: @escaping ((Result<UserSession>) -> Void)) {
        performRequest(for: UserRefreshSessionRequest(), completion: completion)
    }
    
}
