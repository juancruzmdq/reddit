//
//  RemoteService.swift
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import Foundation

/// Result wrapper for Service's responses
///
/// - success: The service finish successfuly and return an object from the App model
/// - failure: There was a issue with the service, use this value to report the error
enum Result<T> {
    case success(_: T)
    case failure(_: RemoteServiceError)
}

enum RemoteServiceError: Error {
    case dataTaskFailed(_: String)
    case invalidURL
    case invalidURLComponents
    case emptyDataResponse
    case conversionToJsonFailed
    case objectParseFailed
    case serviceFailed(code: String, message: String)

    var localizedDescription: String {
        switch self {
        case let .dataTaskFailed(message):
            return "dataTaskFailed: \(message)"
        case .invalidURL:
            return "invalidURL..."
        case .invalidURLComponents:
            return "invalidURLComponents..."
        case .emptyDataResponse:
            return "emptyDataResponse..."
        case .conversionToJsonFailed:
            return "conversionToJsonFailed..."
        case .objectParseFailed:
            return "objectParseFailed..."
        case let .serviceFailed(code, message):
            return "serviceFailed code= \(code), message\(message)"
        }
    }

}

protocol RemoteServiceProtocol {

    var strategies: [RemoteServiceStrategyProtocol]? { get set }

    /// Call an specific endpoint, when finish execute completion block in main thread
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint to call
    ///   - completion: Block to be called when Endpoint's call finish
    @discardableResult
    func call<T>(endpoint: Endpoint<T>, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTaskProtocol?
}

/// Class that works as interface of a remot web service
class RemoteService: RemoteServiceProtocol {

    /// Array of Hooks that allow you to customize the Service call
    var strategies: [RemoteServiceStrategyProtocol]?

    private let session: URLSessionProtocol
    private let baseURL: URL

    /// Create an instance of RemoteService
    ///
    /// - Parameters:
    ///   - baseUrl: base URL service
    ///   - session: Session instance that will be used by this service
    init(baseUrl: URL, session: URLSessionProtocol, strategies: [RemoteServiceStrategyProtocol]? = nil) {
        self.session = session
        self.baseURL = baseUrl
        self.strategies = strategies
    }

    @discardableResult
    func call<T>(endpoint: Endpoint<T>, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTaskProtocol? {
        return self.callWithCompletionWrapper(endpoint: endpoint) { (result) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    @discardableResult
    func callWithCompletionWrapper<T>(endpoint: Endpoint<T>, completion: @escaping (Result<T>) -> Void) -> URLSessionDataTaskProtocol? {

        guard let urlComponents = self.buildURLComponents(for: endpoint) else {
            completion(.failure(RemoteServiceError.invalidURLComponents))
            return nil
        }

        guard let url = urlComponents.url else {
            completion(.failure(RemoteServiceError.invalidURL))
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        self.serviceCallStart(for: endpoint)

        var dataTask: URLSessionDataTaskProtocol?
        dataTask = self.session.dataTask(with: request) { [weak self] data, _, error in

            guard let strongSelf = self else { return }

            strongSelf.serviceCallFinish(for: endpoint)

            if let error = error {
                completion(.failure(RemoteServiceError.dataTaskFailed(error.localizedDescription)))
            } else if let data = data {

                if let error = self?.serviceValidate(data: data, for: endpoint) {
                    completion(.failure(error))
                    return
                }

                completion(endpoint.decode(data) )

            } else {
                completion(.failure(RemoteServiceError.emptyDataResponse))
            }
        }
        dataTask?.resume()

        return dataTask
    }

    func buildURLComponents<T>(for endpoint: Endpoint<T>) -> URLComponents? {

        switch endpoint.method {
        case .get:
            if var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) {
                // build basic URL components with endpoint data
                urlComponents.queryItems = endpoint.parameters?.compactMap {arg in
                    let (key, value) = arg
                    return URLQueryItem(name: key, value: value as? String)
                }
                urlComponents.path += endpoint.path

                let strategies = (self.strategies ?? []) + (endpoint.strategies ?? [])
                strategies
                    .compactMap { $0 as? RemoteServiceURLStrategyProtocol }
                    .forEach { strategy in
                        urlComponents = strategy.urlComponents(components: urlComponents)
                }

                return urlComponents
            }
        default:
            if var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) {
                urlComponents.path += endpoint.path
                return urlComponents
            }
        }

        return nil

    }

    func serviceCallStart<T>(for endpoint: Endpoint<T>) {
        let strategies = (self.strategies ?? []) + (endpoint.strategies ?? [])
        strategies
            .compactMap { $0 as? RemoteServiceFinishStartStrategyProtocol }
            .forEach { strategy in
            strategy.serviceCallStart()
        }
    }

    func serviceCallFinish<T>(for endpoint: Endpoint<T>) {
        let strategies = (self.strategies ?? []) + (endpoint.strategies ?? [])
        strategies
            .compactMap { $0 as? RemoteServiceFinishStartStrategyProtocol }
            .forEach { strategy in
                strategy.serviceCallFinish()
        }

    }

    func serviceValidate<T>(data: Data, for endpoint: Endpoint<T>) -> RemoteServiceError? {
        let strategies = ((self.strategies ?? []) + (endpoint.strategies ?? []))
            .compactMap { $0 as? RemoteServiceResponseValidationStrategyProtocol }

        let errors: [RemoteServiceError]? = strategies.compactMap { strategy in
            if let error = strategy.serviceValidate(data: data) {
                return error
            }
            return nil
        }

        return errors?.first
    }
}
