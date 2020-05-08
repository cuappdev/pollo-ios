//
//  Analytics.swift
//  AppDevAnalytics
//
//  Created by Kevin Chan on 9/4/19.
//  Copyright © 2019 Kevin Chan. All rights reserved.
//

import Crashlytics

class AppDevAnalytics {

    static let shared = AppDevAnalytics()

    private init() {}

    func log(_ payload: Payload) {
        #if !DEBUG
        let fabricEvent = payload.convertToFabric()
        Answers.logCustomEvent(withName: fabricEvent.name, customAttributes: fabricEvent.attributes)
        #endif
    }

}
