//
//  DraftEndpoints.swift
//  Clicker
//
//  Created by Matthew Coufal on 2/2/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation

extension Endpoint {
    
    private struct DraftBody: Codable {
        
        var text: String
        var options: [String]
        
        init(text: String, options: [String]) {
            self.text = text
            self.options = options
        }
        
    }
    
    static func getDrafts() -> Endpoint {
        return Endpoint(path: "/drafts", headers: headers)
    }
    
    static func createDraft(text: String, options: [String]) -> Endpoint {
        let body = DraftBody(text: text, options: options)
        return Endpoint(path: "/drafts", headers: headers, body: body)
    }
    
    static func updateDraft(id: String, text: String, options: [String]) -> Endpoint {
        let body = DraftBody(text: text, options: options)
        return Endpoint(path: "/drafts/\(id)", headers: headers, body: body)
    }
    
    static func deleteDraft(with id: String) -> Endpoint {
        return Endpoint(path: "/drafts/\(id)", headers: headers, method: EndpointMethod.delete)
    }
    
}
