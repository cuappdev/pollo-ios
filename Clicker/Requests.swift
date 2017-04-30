//
//  Requests.swift
//  Clicker
//
//  Created by Daniel Li on 3/26/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import Alamofire
import SwiftyJSON
import GoogleSignIn

//// -- SIGN IN 

struct SignInRequest: NetworkRequest {
    
    let route: String = "/auth/signin", method: HTTPMethod = .post
    var parameters: [String : Any] {
        return [
            "idToken": GIDSignIn.sharedInstance().currentUser.authentication.idToken
        ]
    }
    
    typealias ResponseType = User
    func process(json: JSON) throws -> User {
//        guard let userDict = json.dictionaryObject else {
            throw NetworkError.badJsonFormatting
//        }
//        return User(value: userDict)
    }
}

//// -- CLASSES

struct CreateClassRequest: NetworkRequest {
    
    let courseNumber: Int
    let semester: String
    let course: String
    let courseName: String
    let netIds: [String]
    let time: String // Will be our own Time struct
    let place: String
    
    let route = "/classes", method: HTTPMethod = .post
    var parameters: [String : Any] {
        return [
            "courseNumber": courseNumber,
            "semester": semester,
            "course": course,
            "courseName": courseName,
            "professorNetids": netIds,
            "time": time,
            "place": place
        ]
    }
    
    typealias ResponseType = Int
    func process(json: JSON) throws -> Int {
        guard let id = json["courseId"].int else {
            throw NetworkError.badJsonFormatting
        }
        
        return id
    }
}

struct SearchClassesRequest: NetworkRequest {
    
    let query: String
    
    let route: String = "/classes"
    var parameters: [String : Any] {
        return [
            "query" : query
        ]
    }
    
    typealias ResponseType = [Class]
    func process(json: JSON) throws -> [Class] {
        // NEEDS TESTING
        guard let classesJson = json["classes"].arrayObject else {
            throw NetworkError.badJsonFormatting
        }
        
        return classesJson.map { Class(value: $0) }
    }
}

struct GetClassesRequest: NetworkRequest {
    
    let route: String = "/classes/enrolled"
    
    typealias ResponseType = [Class]
    func process(json: JSON) throws -> [Class] {
        // NEEDS TESTING
        guard let classesJSON = json["classes"].arrayObject else {
            throw NetworkError.badJsonFormatting
        }
        
        return classesJSON.map { Class(value: $0) }
    }
}

struct JoinClassRequest: NetworkRequest {
    
    let courseId: Int
    
    var route: String {
        return "/classes/enrolled/\(courseId)"
    }

    typealias ResponseType = Bool
    func process(json: JSON) throws -> Bool {
        return json["message"] == "success"
    }
}

/*
struct UpdateClassRequest: CreateClassRequest {
    
    let courseId: Int

    var route: String {
        return "/classes/update/\(courseId)"
    }
    
    typealias ResponseType = Bool
    func process(json: JSON) throws -> Bool {
        return json["message"] == "success"
    }
}
 */

struct DeleteClassRequest: NetworkRequest {
    
    let courseId: Int
    
    let route = "/classes"
    var parameters: [String : Any] {
        return ["courseId": courseId]
    }
    
    typealias ResponseType = Bool
    func process(json: JSON) throws -> Bool {
        return json["message"] == "success"
    }
}

//// -- LECTURES
