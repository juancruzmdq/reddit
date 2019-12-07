//
//  RedditEndPoint.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

/// Set of Reddit endpoints
enum RedditEndPoint {
    /// Namespace for "/top"
    ///
    /// - TopList: return a list of post
    enum TopList {
        private static let path = "/top"

        static func get() -> Endpoint<PostList> {
            return Endpoint(method: .get,
                            path: RedditEndPoint.TopList.path)
        }
    }

}
