//
//  DraftEndpoints.swift
//  Pollo
//
//  Created by Matthew Coufal on 2/2/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {
    
    private struct DraftBody: Codable {
        
        var options: [String]
        var text: String
        
        init(text: String, options: [String]) {
            self.options = options
            self.text = text
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
        return Endpoint(path: "/drafts/\(id)", headers: headers, body: body, method: .put)
    }
    
    static func deleteDraft(with id: String) -> Endpoint {
        return Endpoint(path: "/drafts/\(id)", headers: headers, method: .delete)
    }
    
}
