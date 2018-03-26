import Foundation
import UIKit

struct Keys {
    static var apiURL: String {
        #if DEV_SERVER
            return stringValue(for: "api-dev-url")
        #endif

        return stringValue(for: "api-url")
    }

    static var fabricAPIKey: String {
        return stringValue(for: "fabric-api-key")
    }

    private init() {}

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()

    private static func stringValue(for key: String) -> String {
        return keyDict[key] as? String ?? ""
    }
}

struct Device {
    static let id: String = {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            return deviceId
        } else {
            return UUID().uuidString
        }
    }()

    private init() {}
}

