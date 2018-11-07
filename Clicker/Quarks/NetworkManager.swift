//
//  NetworkManager.swift
//  Clicker
//
//  Created by Matthew Coufal on 11/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum Result<T> {
    case value(T)
    case error(Error)
}

enum PolloError: Error {
    case invalidResponse
}

enum PolloAPIVersion {
    case version(Int)
    case none
}

struct APIResponse<T: Codable>: Codable {
    let data: APIData<T>
    let success: Bool
}

struct APIData<T: Codable>: Codable {
    let node: T?
    let nodes: [Node<T>]?
}

struct Node<T: Codable>: Codable {
    let value: T
    
    enum CodingKeys: String, CodingKey {
        case value = "node"
    }
}

protocol APIRequest {
    var route: String { get }
    var parameters: Parameters { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
}

extension APIRequest {
    var parameters: Parameters {
        return [:]
    }

    var method: HTTPMethod {
        return .get
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

class NetworkManager {
    
    static let host: String = Keys.hostURL.value + "/api"
    static let apiVersion: PolloAPIVersion = .version(2)
    static let headers: HTTPHeaders = ["Authorization": "Bearer \(User.userSession?.accessToken ?? "")"]
    
    class func getBaseURL() -> String {
        switch apiVersion {
        case .version(let version):
            return "\(host)/v\(version)"
        case .none:
            return host
        }
    }
    
    class func performRequest<T: Codable>(for apiRequest: APIRequest, completion: ((Result<T>) -> Void)?) {
        let urlString = "\(getBaseURL())\(apiRequest.route)"
        guard let url = URL(string: urlString) else { return }
        Alamofire.request(url, method: apiRequest.method, parameters: apiRequest.parameters, encoding: apiRequest.encoding, headers: headers).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode(APIResponse<T>.self, from: data)
                    let responseData = apiResponse.data
                    if let node = responseData.node {
                        completion?(.value(node))
                    }
                } catch {
                    completion?(.error(PolloError.invalidResponse))
                }
            case .failure(let error):
                completion?(.error(error))
            }
        }
    }
    
}
