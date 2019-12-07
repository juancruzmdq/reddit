//
//  RemoteServiceStrategies.swift
//
//  Created by Juan Cruz Ghigliani on 10/5/18.
//

import Foundation

struct NetworkActivityIndicatorStrategy: RemoteServiceFinishStartStrategyProtocol {
    /// Network activity handler
    var networkActivityIndicator: NetworkActivityIndicatorProtocol?

    func serviceCallStart() {
        self.networkActivityIndicator?.startNetworkActivity()
    }

    func serviceCallFinish() {
        self.networkActivityIndicator?.finishNetworkActivity()
    }

}

/// This hook will inject the {Key: Value} in all get request API calls
struct KeyValueQueryItemStrategy: RemoteServiceURLStrategyProtocol {
    var key: String
    var value: String

    func urlComponents(components: URLComponents) -> URLComponents {
        var mycomponents = components
        mycomponents.queryItems?.append(URLQueryItem(name: key, value: value))
        return mycomponents
    }

}
