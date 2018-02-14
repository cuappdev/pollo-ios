//
//  PollQuark.swift
//  Clicker
//
//  Created by Kevin Chan on 2/13/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import Alamofire
import Neutron
import SwiftyJSON

struct GeneratePollCode : ClickerQuark {
    
    typealias ResponseType = String
    
    var route: String {
        return "/v1/generate/code"
    }
    let host: String = "http://localhost:3000/api"
    let method: HTTPMethod = .get
    
    func process(element: Element) throws -> String {
        switch element {
        case.node(let node):
            print(node)
            guard let code = node["code"].string else {
                throw NeutronError.badResponseData
            }
            return code
        default: throw NeutronError.badResponseData
    }
}


}


