//
//  Endpoint.swift
//  Cornell AppDev
//
//  Created by Austin Astorga on 11/27/18.
//  Copyright © 2018 Austin Astorga. All rights reserved.
//

import Foundation

public struct Endpoint {
    public static let config: Endpoint.Config = Endpoint.Config()

    let host: String?
    let scheme: String?
    let port: Int?
    let useCommonHeaders: Bool
    let useCommonPath: Bool

    let path: String
    let queryItems: [URLQueryItem]
    let headers: [String: String]
    let body: Data?
    let method: Endpoint.Method
}

// Endpoint sub classes and enums
extension Endpoint {
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
    }

    public class Config {
        public var scheme: String?
        public var host: String?
        public var port: Int?
        public var commonPath: String?
        public var commonHeaders: [String: String]?
    }
}

// Endpoint initializers
extension Endpoint {
    /// General initializer with body
    public init<T: Codable>(path: String,
                            queryItems: [URLQueryItem] = [],
                            headers: [String: String] = [:],
                            body: T? = nil,
                            method: Endpoint.Method = .get,
                            useCommonHeaders: Bool = true,
                            useCommonPath: Bool = true,
                            customHost: String? = nil,
                            customScheme: String? = nil,
                            customPort: Int? = nil) {
        self.path = path
        self.queryItems = queryItems

        var modifiedHeaders = headers
        if modifiedHeaders["Content-Type"] == nil {
            // Set Content-Type to application/json so backend can identify json body
            modifiedHeaders["Content-Type"] = "application/json"
        }
        self.headers = modifiedHeaders

        self.method = (body != nil) ? .post : method
        self.body = try? JSONEncoder().encode(body)

        self.host = customHost
        self.port = customPort
        self.scheme = customScheme
        self.useCommonPath = useCommonPath
        self.useCommonHeaders = useCommonHeaders
    }

    /// General initializer without body
    public init(path: String,
                            queryItems: [URLQueryItem] = [],
                            headers: [String: String] = [:],
                            method: Endpoint.Method = .get,
                            useCommonHeaders: Bool = true,
                            useCommonPath: Bool = true,
                            customHost: String? = nil,
                            customScheme: String? = nil,
                            customPort: Int? = nil) {
        self.path = path
        self.queryItems = queryItems

        self.headers = headers

        self.method = method
        self.body = nil
        self.host = customHost
        self.port = customPort
        self.scheme = customScheme
        self.useCommonPath = useCommonPath
        self.useCommonHeaders = useCommonHeaders
    }

    /// POST initializer
    public init<T: Codable>(path: String,
                            headers: [String: String] = [:],
                            body: T,
                            useCommonHeaders: Bool = true,
                            useCommonPath: Bool = true,
                            customHost: String? = nil,
                            customScheme: String? = nil,
                            customPort: Int? = nil) {
        self.path = path
        self.queryItems = []
        self.method = .post

        var modifiedHeaders = headers
        if modifiedHeaders["Content-Type"] == nil {
            // Set Content-Type to application/json so backend can identify json body
            modifiedHeaders["Content-Type"] = "application/json"
        }
        self.headers = modifiedHeaders

        // Encode body
        self.body = try? JSONEncoder().encode(body)

        self.host = customHost
        self.port = customPort
        self.scheme = customScheme
        self.useCommonPath = useCommonPath
        self.useCommonHeaders = useCommonHeaders
    }

    /// GET initializer
    public init(path: String,
                queryItems: [URLQueryItem] = [],
                headers: [String: String] = [:],
                useCommonHeaders: Bool = true,
                useCommonPath: Bool = true,
                customHost: String? = nil,
                customScheme: String? = nil,
                customPort: Int? = nil) {
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
        self.method = .get
        self.body = nil

        self.host = customHost
        self.port = customPort
        self.scheme = customScheme
        self.useCommonPath = useCommonPath
        self.useCommonHeaders = useCommonHeaders
    }
}

// Endpoint url
extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    public var url: URL? {
        var components = URLComponents()
        // Assert required values have been set
        assert(Endpoint.config.scheme != nil, "Endpoint: scheme has not been set")
        assert(Endpoint.config.host != nil, "Endpoint: host has not been set")
        
        components.scheme = scheme != nil ? scheme! : Endpoint.config.scheme
        components.host = host != nil ? host! : Endpoint.config.host

        // Check for common path variable
        if let cPath = Endpoint.config.commonPath, useCommonPath {
            components.path = "\(cPath)\(path)"
        } else {
            components.path = path
        }

        // Check if port has been set
        if let port = port {
            components.port = port
        } else if let port = Endpoint.config.port {
            components.port = port
        }
        
        components.queryItems = queryItems
        return components.url
    }

    public var urlRequest: URLRequest? {
        guard let unwrappedURL = url else { return nil }
        var request = URLRequest(url: unwrappedURL)
        if let cHeaders = Endpoint.config.commonHeaders, useCommonHeaders {
            cHeaders.forEach { (key, value) in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = method.rawValue
        request.httpBody = body

        return request
    }
}

