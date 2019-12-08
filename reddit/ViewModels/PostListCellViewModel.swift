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

    weak var postListManager: PostListModelManagerProtocol?

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

    var created: String {
        guard let created = post?.created else {
            return ""
        }

        let createdDate = Date(timeIntervalSince1970: TimeInterval(created))
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full

        let relativeDate = formatter.localizedString(for: createdDate, relativeTo: Date())

        return relativeDate
    }

    var numComments: String {
        "\(post?.numComments ?? 0) Commments"
    }

    var thumbnail: String? {
        post?.thumbnail
    }

    var visited: Bool {
        post?.visited ?? false
    }

    init(with post: Post, postListManager: PostListModelManagerProtocol) {
        self.post = post
        self.postListManager = postListManager
    }

    func dismiss() {
        guard let post = self.post else { return }
        postListManager?.dismiss(post: post)
    }
}
