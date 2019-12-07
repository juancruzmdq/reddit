//
//  Post.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

class Post {
    var title: String?
    var author: String?
    var created: Int?
    var thumbnail: String?
    var numComments: Int = 0
    var visited: Bool = false
}

extension Post: Parseable {
    typealias ParserType = PostParser
}

struct PostParser: Parser {

    static func parse(_ dictionaryRepresentation: [String: Any]) -> Post? {

        guard let data = dictionaryRepresentation["data"] as? [String: Any] else {
            return Post()
        }

        let post = Post()

        post.title = data["title"] as? String
        post.author = data["author"] as? String
        post.created = data["created"] as? Int
        post.thumbnail = data["thumbnail"] as? String
        post.numComments = data["num_comments"] as? Int ?? 0
        post.visited = data["visited"] as? Bool ?? false

        return post
    }

}
