import Foundation
import UIKit

/* hidden Keys.plist for sensitive information */
enum Keys: String {
    case apiURL = "api-url"
    case apiDevURL = "api-dev-url"
    case fabricAPIKey = "fabric-api-key"

    var value: String {
        return Keys.keyDict[rawValue] as! String
    }

    static var hostURL: Keys {
        #if DEV_SERVER
            return Keys.apiDevURL
        #else
            return Keys.apiURL
        #endif
    }

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
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

