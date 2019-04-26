//
//  Response.swift
//  Clicker
//
//  Created by Mindy Lou on 4/25/19.
//  Copyright © 2019 CornellAppDev. All rights reserved.
//

import Foundation
import FutureNova

extension Endpoint {
    static var apiVersion: Int? { return 2 }
}

struct Response<T: Codable>: Codable {

    var success: Bool
    var data: T

}

struct DeleteResponse: Codable {
    var success: Bool
}
