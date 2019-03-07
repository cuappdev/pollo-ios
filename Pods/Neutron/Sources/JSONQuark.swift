import Alamofire
import SwiftyJSON
import PromiseKit

/// A `JSONQuark` is a child protocol of `Quark` that gives each quark a response in the form of
/// `JSON` rather than `Data`.
public protocol JSONQuark: Quark {
    func process(response: JSON) throws -> ResponseType
}

public extension JSONQuark {
    public func process(response: Data) throws -> ResponseType {
        return try process(response: JSON(data: response))
    }
}
