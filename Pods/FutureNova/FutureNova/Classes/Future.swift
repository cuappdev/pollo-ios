/**
 *  Swift by Sundell sample code (Additions by Austin Astorga)
 *  Copyright (c) John Sundell 2017
 *  See LICENSE file for license
 *
 *  Read the blog post at https://swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift
 */

import Foundation

public typealias Networking = (Endpoint) -> Future<Data>

public enum Result<Value> {
    case value(Value)
    case error(Error)
}

extension Result {
    func resolve() throws -> Value {
        switch self {
        case .value(let value):
            return value
        case .error(let error):
            throw error
        }
    }
}

extension Result where Value == Data {
    func decoded<T: Decodable>() throws -> T {
        let decoder = JSONDecoder()
        let data = try resolve()
        return try decoder.decode(T.self, from: data)
    }
}

public class Future<Value> {
    fileprivate var result: Result<Value>? {
        didSet { result.map(report) }
    }

    var currentTask: URLSessionDataTask?

    private lazy var callbacks = [(Result<Value>) -> Void]()

    public func observe(with callback: @escaping (Result<Value>) -> Void) {
        callbacks.append(callback)
        result.map(callback)
    }

    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

extension Future {
    public func chained<NextValue>(with closure: @escaping (Value) throws -> Future<NextValue>) -> Future<NextValue> {
        let promise = Promise<NextValue>()

        observe { result in
            switch result {
            case .value(let value):
                do {
                    let future = try closure(value)

                    future.observe { result in
                        switch result {
                        case .value(let value):
                            promise.resolve(with: value)
                        case .error(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .error(let error):
                promise.reject(with: error)
            }
        }

        return promise
    }

    public func transformed<NextValue>(with closure: @escaping (Value) throws -> NextValue) -> Future<NextValue> {
        return chained { value in
            return try Promise(value: closure(value))
        }
    }
}

public class Promise<Value>: Future<Value> {

    public init(value: Value? = nil) {
        super.init()
        result = value.map(Result.value)
    }

    public init(error: Error) {
        super.init()
        result = .error(error)
    }

    public func resolve(with value: Value) {
        result = .value(value)
    }

    public func reject(with error: Error) {
        result = .error(error)
    }
}

extension URLSession {

    public enum EndpointErrors: Error {
        case badUrlRequest
    }

    public func request(endpoint: Endpoint) -> Future<Data> {
        let promise = Promise<Data>()

        guard let urlRequest = endpoint.urlRequest else {
            promise.reject(with: EndpointErrors.badUrlRequest)
            return promise
        }

        let task =  dataTask(with: urlRequest) { data, _, error in
            if error?._code == NSURLErrorCancelled {
                return
            }

            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }

        task.resume()
        promise.currentTask = task

        return promise
    }
}

extension Future where Value == Data {


    public func decode<NextValue: Codable>(_ type: NextValue.Type) -> Future<NextValue> {
        return transformed {
            //Uncomment this line to see what is being decoded
            //print(String.init(data: $0, encoding: .utf8))
            return try JSONDecoder().decode(NextValue.self, from: $0)
        }
    }
    
    public func decode<NextValue: Codable>() -> Future<NextValue> {
        return transformed {
            //Uncomment this line to see what is being decoded
            //print(String.init(data: $0, encoding: .utf8))
            return try JSONDecoder().decode(NextValue.self, from: $0)
        }
    }
}

// This turns an (A) -> B function into a () -> B function,
// by using a constant value for A.
public func combine<A, B>(_ value: A,
                   with closure: @escaping (A) -> B) -> () -> B {
    return { closure(value) }
}

// This turns an (A) -> B and a (B) -> () -> C function into a
// (A) -> C function, by chaining them together.
public func chain<A, B, C>(
    _ inner: @escaping (A) -> B,
    to outer: @escaping (B) -> () -> C
    ) -> (A) -> C {
    // We pass the result
    // of the inner function into the outer one — but since that
    // now returns another function, we'll also call that one.
    return { outer(inner($0))() }
}
