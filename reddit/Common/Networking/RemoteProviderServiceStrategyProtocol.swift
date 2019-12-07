//
//  RemoteServiceStrategyProtocol.swift
//
//  Created by Juan Cruz Ghigliani on 10/5/18.
//

import Foundation

/// Base protocol to implement different strategies in a Remote sevice
protocol RemoteServiceStrategyProtocol { }

/// This strategy allows you to parse the url request before execute the service call
protocol RemoteServiceURLStrategyProtocol: RemoteServiceStrategyProtocol {
    func urlComponents(components: URLComponents) -> URLComponents
}

/// This strategy allows you to react to the begining/end ofa service call
protocol RemoteServiceFinishStartStrategyProtocol: RemoteServiceStrategyProtocol {
    func serviceCallStart()
    func serviceCallFinish()
}

/// This strategy allows you to validate the response data and return an error if need ( return nil if everything is ok )
protocol RemoteServiceResponseValidationStrategyProtocol: RemoteServiceStrategyProtocol {
    func serviceValidate(data: Data) -> RemoteServiceError?
}
