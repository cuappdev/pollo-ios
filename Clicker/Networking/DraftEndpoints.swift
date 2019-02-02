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
        return Endpoint(path: "/drafts")
    }
    
    static func createDraft(text: String, options: [String]) -> Endpoint {
        let body = DraftBody(text: text, options: options)
        return Endpoint(path: "/drafts", body: body)
    }
    
    static func updateDraft(id: Int, text: String, options: [String]) -> Endpoint {
        let body = DraftBody(text: text, options: options)
        return Endpoint(path: "/drafts/\(id)", body: body)
    }
    
    static func deleteDraft(with id: Int) -> Endpoint {
        return Endpoint(path: "/drafts/\(id)", method: EndpointMethod.delete)
    }
    
}
