//
//  NetworkActivityIndicator.swift
//
//  Created by Juan Cruz Ghigliani on 8/5/18.
//

import Foundation

/// Protocol used to give feedback to the user about the network activity
protocol NetworkActivityIndicatorProtocol: class {

    /// A new network request started
    func startNetworkActivity()

    /// A request just finished
    func finishNetworkActivity()
}
