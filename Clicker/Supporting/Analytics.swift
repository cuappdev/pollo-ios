//
//  Analytics.swift
//  Clicker
//
//  Created by Kevin Chan on 10/25/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

/// Logging based on TCAT-ios

import Crashlytics
import SwiftyJSON

class Analytics {
    static let shared = Analytics()

    func log(with payload: Payload) {
        let fabricEvent = payload.convertToFabric()
        Answers.logCustomEvent(withName: fabricEvent.name, customAttributes: fabricEvent.attributes)
        print("Logging \(fabricEvent.name):\(fabricEvent.attributes ?? [:])")
    }
}

/// Log Device Information
struct DeviceInfo: Codable {
    let model = Device.modelName
    let appVersion = App.version
}

// MARK: - Payloads
extension Payload {

    func convertToFabric() -> (name: String, attributes: [String : Any]?) {
        let event = self.toEvent()
        do {
            let data = try event.serializeJson()
            let json = try JSON(data: data)

            var dict: [String : Any] = [:]
            for (key, value) in json["payload"] {
                if key == "deviceInfo" {
                    for (infoKey, infoValue) in value {
                        dict[infoKey] = infoValue.stringValue
                    }
                } else {
                    dict[key] = value.stringValue
                }
            }

            return(name: json["event_type"].stringValue, dict)
        } catch {
            print("error here!")
            return ("", nil)
        }
    }

}

struct GroupCreatedPayload: Payload {
    static let eventName: String = "Group Created"
    let deviceInfo = DeviceInfo()

    let code: String
}
