//
//  RedditService.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

/// Protocol to be implemented by the RedditServiceConfig provider
protocol RedditServiceConfigProtocol {
    var redditKey: String { get }
    var redditSecret: String { get }
    var redditBaseURL: String { get }
}

protocol RedditServiceProtocol {

    /// Return a list with the Top  posts
    ///
    /// - Parameters:
    ///   - completion: callback with the service response
    func top(completion: @escaping (Result<PostList>) -> Void)
}

/// Service to interact with the Reddit
class RedditService {

    private let redditKey: String
    private let redditSecret: String
    private let redditBaseURL: String
    private let remoteService: RemoteServiceProtocol

    /// Create a new Reddit service with the given key
    ///
    /// - Parameter config: instance of a RedditServiceProtocol
    /// - networkActivityIndicator: Activity indicator handler
    init(config: RedditServiceConfigProtocol,
         networkActivityIndicator: NetworkActivityIndicatorProtocol? = nil) {

        self.redditKey = config.redditKey
        self.redditSecret = config.redditSecret
        self.redditBaseURL = config.redditBaseURL

        let session = URLSession(configuration: .default)
        let url = URL(string: self.redditBaseURL)!

        self.remoteService = RemoteService(baseUrl: url,
                                           session: session,
                                           strategies: [NetworkActivityIndicatorStrategy(networkActivityIndicator: networkActivityIndicator)])
    }

}

extension RedditService: RedditServiceProtocol {
    func top(completion: @escaping (Result<PostList>) -> Void) {
        let endPoint = RedditEndPoint.TopList.get()
        self.remoteService.call(endpoint: endPoint, completion: completion)
    }

}
