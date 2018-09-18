//
//  Parser.swift
//  Clicker
//
//  Created by Kevin Chan on 9/7/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Parser {
    associatedtype itemType
    
    static func parseItem(json: JSON) -> itemType
}
