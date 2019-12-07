//
//  URLSessionProtocol.swift
//
//  Created by Juan Cruz Ghigliani on 18/5/18.
//

import Foundation

/// Use this protocol to hide URLSession in RemoteService, and simplify testing and mocking
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

/// Use this protocol to hide URLSessionDataTask in RemoteService, and simplify testing and mocking
protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {

    /// Override the dataTask implementetion to give you the ability tu create a URLSessionDataTaskProtocol instance in a URLSession
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let urlSessionDataTask = self.dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
        return  urlSessionDataTask as URLSessionDataTaskProtocol
    }

}
