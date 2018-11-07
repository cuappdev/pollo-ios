//
//  NetworkManager+Draft.swift
//  Clicker
//
//  Created by Matthew Coufal on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension NetworkManager {
    
    struct CreateDraftRequest: APIRequest {
        let route: String = "/drafts"
        let parameters: Parameters
        let method: HTTPMethod = .post
    }
    
    class func createDraft(text: String, options: [String], completion: @escaping ((Result<Draft>) -> Void)) {
        let parameters: Parameters = ["text": text, "options": options]
        let apiRequest = CreateDraftRequest(parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct DeleteDraftRequest: APIRequest {
        let route: String
        let method: HTTPMethod = .delete
    }
    
    class func deleteDraft(id: String, completion: @escaping ((Result<Draft>) -> Void)) {
        let route: String = "/drafts\(id)"
        let apiRequest = DeleteDraftRequest(route: route)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct UpdateDraftRequest: APIRequest {
        let route: String
        let parameters: Parameters
        let method: HTTPMethod = .put
    }
    
    class func updateDraft(id: String, text: String, options: [String], completion: @escaping ((Result<Draft>) -> Void)) {
        let route: String = "/drafts/\(id)"
        let parameters: Parameters = ["text": text, "options": options]
        let apiRequest = UpdateDraftRequest(route: route, parameters: parameters)
        performRequest(for: apiRequest, completion: completion)
    }
    
    struct GetDraftsRequest: APIRequest {
        let route: String = "/drafts"
        let method: HTTPMethod = .get
    }
    
    class func getDrafts(completion: @escaping ((Result<[Draft]>) -> Void)) {
        performRequest(for: GetDraftsRequest(), completion: completion)
    }
    
}
