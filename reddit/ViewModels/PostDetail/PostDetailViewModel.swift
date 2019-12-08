//
//  PostDetailViewModel.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

protocol PostDetailViewModelDelegate: class {
    func postDetailViewModelUpdated(_ postDetailViewModel: PostDetailViewModel)
}

class PostDetailViewModel {
    weak var delegate: PostDetailViewModelDelegate?

    var post: Post? {
        didSet {
            delegate?.postDetailViewModelUpdated(self)
        }
    }

    var title: String {
        post?.title ?? "..."
    }

    var author: String {
        post?.author ?? "..."
    }

    var thumbnail: String? {
        post?.thumbnail
    }

    init(with post: Post) {
        self.post = post
    }
}
