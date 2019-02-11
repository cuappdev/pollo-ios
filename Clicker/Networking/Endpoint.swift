//
//  Endpoint.swift
//  Clicker
//
//  Created by Matthew Coufal on 1/30/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation


enum EndpointMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

/// Looks at Secrets/Keys.plist file which should contain as key:
/// - "api-url" should be the host of the deployed backend url
enum SecretKeys: String {
    case apiURL = "api-url"
    case apiDevURL = "api-dev-url"
    
    var value: String {
        switch self {
        case .apiDevURL: return "localhost"
        case .apiURL: return SecretKeys.keyDict[rawValue] as! String
        }
    }
    
    static var hostURL: SecretKeys {
        #if DEV_SERVER
        return SecretKeys.apiDevURL
        #else
        return SecretKeys.apiURL
        #endif
    }
    
    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}


struct Endpoint {
    static var apiVersion: Int? { return 2 }
    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let method: EndpointMethod
}

extension Endpoint {
    /// General initializer
    init<T: Codable>(path: String, queryItems: [URLQueryItem] = [], headers: [String: String] = [:], body: T? = nil, method: EndpointMethod = .get) {
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.method = (body != nil) ? .post : method
        self.body = try? JSONEncoder().encode(body)
    }
    
    /// POST initializer
    init<T: Codable>(path: String, headers: [String: String] = [:], body: T, method: EndpointMethod = .post) {
        self.path = path
        self.queryItems = []
        var modifiedHeaders = headers
        modifiedHeaders["Content-Type"] = "application/json"
        self.headers = modifiedHeaders
        self.method = method
        print(body)
        //Encode body
//        self.body = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        self.body = try? JSONEncoder().encode(body)
    }
    
    /// GET and DELETE initializer
    init(path: String, queryItems: [URLQueryItem] = [], headers: [String: String] = [:], method: EndpointMethod = .get) {
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.method = method
        self.body = nil
    }
}

extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "http"
        components.host = SecretKeys.hostURL.value
        if let apiVersion = Endpoint.apiVersion {
            components.path = "/api/v\(apiVersion)\(path)"
        } else {
            components.path = "/api\(path)"
        }
        #if DEV_SERVER
        components.port = 3000
        #endif
        components.queryItems = queryItems
        return components.url
    }
    
    
    var urlRequest: URLRequest? {
        guard let unwrappedURL = url else { return nil }
        var request = URLRequest(url: unwrappedURL)
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if method == .post {
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return request
    }
}
