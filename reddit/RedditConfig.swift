//
//  RedditConfig.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

typealias RedditConfig = ConfigType & RedditServiceConfigProtocol

extension Config: RedditServiceConfigProtocol {
    var redditKey: String { return "I4Rh1kIJ8w1K2g" }
    var redditSecret: String { return "5ZhJny6SxV6kYXgVPr3U39U92rs" }
    var redditBaseURL: String { return "http://88vmz.mocklab.io" }
}
