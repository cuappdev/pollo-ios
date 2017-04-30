//
//  NetworkRequest.swift
//  Clicker
//
//  Created by AE7 on 3/5/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import Alamofire
import SwiftyJSON

let AWS_DEV_URL: String = "http://clicker-dev.us-west-2.elasticbeanstalk.com"

/*
 An `ADNetworkRequest` is a protocol to which structs can conform to create expressive REST API requests.
 */
protocol NetworkRequest {
    associatedtype ResponseType
    
    var baseURL: String { get }
    var route: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : Any] { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
    
    func process(json: JSON) throws -> ResponseType
}

extension NetworkRequest {
    
    var baseURL: String { return AWS_DEV_URL }
    var route: String { return "" }
    var method: HTTPMethod { return .get }
    var parameters: [String : Any] { return [:] }
    var encoding: ParameterEncoding { return URLEncoding.default }
    var headers: HTTPHeaders? { return nil }
    
    func make(onSuccess: ((ResponseType) -> Void)? = nil, onFailure: ((Error) -> Void)? = nil) {
        Alamofire.request(URL(string: baseURL + route)!, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { response in
                print(response.response?.allHeaderFields)
                
                switch response.result {
                case .success(let data):
                    do {
                        let response = try self.process(json: JSON(data))
                        onSuccess?(response)
                    } catch(let error) {
                        onFailure?(error)
                    }
                case .failure(let error):
                    onFailure?(error)
                }
        }
    }
    
    func queue(on queue: OperationQueue, onSuccess: ((ResponseType) -> Void)? = nil, onFailure: ((Error) -> Void)? = nil) {
        queue.addOperation {
            self.make(onSuccess: onSuccess, onFailure: onFailure)
        }
    }
}

/*
 `ADNetworkError` represents custom errors from backend responses
 */
enum NetworkError: Error {
    case badJsonFormatting
    
    var localizedDescription: String {
        switch self {
        case .badJsonFormatting:
            return "Unexpected values in JSON"
        }
    }
}
