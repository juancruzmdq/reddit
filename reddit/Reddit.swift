//
//  Reddit.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

class Reddit {

    static let shared = Reddit()

    let config: RedditConfig
    let networkActivityIndicator: NetworkActivityIndicatorProtocol
    let redditService: RedditServiceProtocol

    init() {

        self.config = Config(bundle: .main, locale: .current)

        self.networkActivityIndicator = StatusBarNetworkActivityIndicator()

        self.redditService = RedditService(config: self.config,
                                           networkActivityIndicator: self.networkActivityIndicator)

    }
}
