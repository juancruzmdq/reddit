//
//  EndPoint.swift
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

typealias Parameters = [String: Any]

typealias Path = String

enum Method: String {
    case get, post, put, patch, delete
}

/// Struct to represent an API's EndPoint
struct Endpoint<Response> {

    /// HTTP Method for this endpoint
    let method: Method

    /// Path of the endpoint, will by added to the service base url
    let path: Path

    /// Dictionary with the key, values that will be sent to the endpoint
    let parameters: Parameters?

    /// Block to Parsing/Decode the service response
    let decode: (Data) -> Result<Response>

    /// Array of Hooks that allow you to customize this endpoint call
    var strategies: [RemoteServiceStrategyProtocol]?

    /// Create an instance of Endpoint
    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil,
         strategies: [RemoteServiceStrategyProtocol]?,
         decode: @escaping (Data) -> Result<Response>) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.strategies = strategies
        self.decode = decode
    }
}

// MARK: - Decodable is available in iOS11
extension Endpoint where Response: Swift.Decodable {

    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil,
         strategies: [RemoteServiceStrategyProtocol]? = nil) {
        self.init(method: method,
                  path: path,
                  parameters: parameters,
                  strategies: strategies) {

            guard let object = try? JSONDecoder().decode(Response.self, from: $0) else {
                return .failure(RemoteServiceError.objectParseFailed)
            }
            return Result.success(object)
        }
    }

}

// MARK: - Before iOS11 use Parseable
extension Endpoint where Response: Parseable {

    init(method: Method = .get,
         path: Path,
         parameters: Parameters? = nil,
         strategies: [RemoteServiceStrategyProtocol]? = nil) {
        self.init(
            method: method,
            path: path,
            parameters: parameters,
            strategies: strategies) { data in
                guard let dictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                    return .failure(RemoteServiceError.conversionToJsonFailed)
                }

                guard let object = Response.ParserType.parse(dictionary) as? Response else {
                    return .failure(RemoteServiceError.objectParseFailed)
                }
                return Result.success(object)

        }
    }

}
