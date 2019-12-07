//
//  PostListCellViewModel.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

protocol PostListCellViewModelDelegate: class {
    func postDetailViewModelUpdated(_ postListCellViewModel: PostListCellViewModel)
}

class PostListCellViewModel {
    weak var delegate: PostListCellViewModelDelegate?

    var post: Post? {
        didSet {
            delegate?.postDetailViewModelUpdated(self)
        }
    }

    var title: String {
        post?.title ?? "..."
    }

    init(with post: Post) {
        self.post = post
    }
}
