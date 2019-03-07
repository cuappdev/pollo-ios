import Alamofire
import PromiseKit

/// A `Quark` is a protocol to which structs can conform to create expressive, self-documenting
/// REST API requests.
///
/// A protocol can also inherit `Quark` and supply its own defaults.
public protocol Quark: CustomStringConvertible {

    /// Required type that the user of the `Quark` wishes to get in return.
    /// The creator of a `Quark` must produce this ResponseType in the required `process` method.
    ///
    /// e.g. A "get all posts" request may want `ResponseType` to be `[Post]`, array of `Post`s
    associatedtype ResponseType

    /// The base host URL for the `Quark`. This requires `http://` or `https
    ///
    /// Default is `http://localhost`.
    var host: String { get }

    /// The version of the API, if any, from which the `Quark` wishes to retrieve.`
    /// If `.versioned`, the protocol will insert the `/v#` route where # is the version number.
    ///
    /// Default is `.none`.
    var api: APIVersion { get }

    /// Required route for the `Quark`, with no default
    ///
    /// e.g. "/posts"
    var route: String { get }

    /// The HTTP method of the `Quark`. See Alamofire's documentation.
    ///
    /// Default is `.get`.
    var method: HTTPMethod { get }

    /// Parameters for the `Quark`.
    ///
    /// Default is empty dictionary.
    var parameters: [String : Any] { get }

    /// Encoding for the parameters.
    ///
    /// Default is `URLEncoding.default`
    var encoding: ParameterEncoding { get }

    /// Headers for the `Quark`.
    ///
    /// Default is empty dictionary.
    var headers: HTTPHeaders { get }

    /// Required method that the creator of the `Quark` must implement. If the network request
    /// is successful, this method will be called with the data from the response body.
    func process(response: Data) throws -> ResponseType
}

/// Version of the server's API.
public enum APIVersion {

    /// No versioning
    case none

    /// Versioned
    case versioned(Int)
}

public extension Quark {

    // String description for CustomStringConvertible
    var description: String {
        return "\(method) request to \(route) with \(encoding), \(parameters) and \(headers)"
    }

    var host: String { return "http://localhost" }

    var api: APIVersion { return .none }

    var apiUrlString: String {
        switch api {
        case .none:
            return ""
        case .versioned(let version):
            return Neutron.apiVersionFormat(version)
        }
    }

    var method: HTTPMethod { return .get }
    var parameters: Parameters { return [:] }
    var encoding: ParameterEncoding { return URLEncoding.default }
    var headers: HTTPHeaders { return [:] }

    func dataRequest() throws -> DataRequest {
        guard let url = URL(string: host + apiUrlString + route) else {
            throw NeutronError.badUrl
        }

        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }

    func make() -> Promise<ResponseType> {
        do {
            return try dataRequest()
                .validate()
                .responseData()
                .map { (data, _) -> ResponseType in
                    return try self.process(response: data)
                }
        } catch {
            return Promise<ResponseType>(error: error)
        }
    }
}

///
/// A `NeutronError` represents custom errors from networking
public enum NeutronError: Error {
    case badResponseData
    case badUrl

    public var localizedDescription: String {
        switch self {
        case .badResponseData:
            return "Unexpected response data"
        case .badUrl:
            return "Bad url"
        }
    }
}
