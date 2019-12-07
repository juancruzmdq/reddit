//
//  PostList.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

class PostList {
    var after: String?
    var before: String?
    var posts: [Post] = []
}

extension PostList: Parseable {
    typealias ParserType = PostListParser
}

struct PostListParser: Parser {

    static func parse(_ dictionaryRepresentation: [String: Any]) -> PostList? {

        let postList = PostList()

        guard let data = dictionaryRepresentation["data"] as? [String: Any] else {
            return postList
        }

        postList.after = data["after"] as? String
        postList.before = data["before"] as? String

        guard let childrens = data["children"] as? [[String: Any]] else {
            return postList
        }

        postList.posts = childrens.compactMap { children in
            return Post.ParserType.parse(children)
        }

        return postList
    }

}
