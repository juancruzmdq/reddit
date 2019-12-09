//
//  PostListViewModel.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

protocol PostListModelManagerProtocol: class {
    func dismiss(post: Post)
    func dismissAll()
    func visit(_ post: Post)
}

protocol PostListViewModelDelegate: class {
    func postListViewModelLoadingUpdated(_ postListViewModel: PostListViewModel)
    func postListViewModelListUpdated(_ postListViewModel: PostListViewModel)
    func postListViewModel(_ postListViewModel: PostListViewModel, reportError: Error)
    func postListViewModelDeleted(_ postListViewModel: PostListViewModel, at indexes: [IndexPath])
}

class PostListViewModel {

    private let redditService: RedditServiceProtocol

    weak var delegate: PostListViewModelDelegate?

    var postList: PostList? {
        didSet {
            delegate?.postListViewModelListUpdated(self)
        }
    }

    var loading: Bool = false {
        didSet {
            delegate?.postListViewModelLoadingUpdated(self)
        }
    }

    var posts: [Post] {
        postList?.posts ?? []
    }

    init(with redditService: RedditServiceProtocol) {
        self.redditService = redditService
    }

    func loadPosts() {
        loading = true
        redditService.top { [weak self] result in

            guard let strongSelf = self else { return }
            strongSelf.loading = false

            switch result {
            case let .success(postList):
                strongSelf.postList = postList
            case let .failure(error):
                strongSelf.delegate?.postListViewModel(strongSelf, reportError: error)
            }
        }
    }

    func remove(at index: Int) {
        postList?.posts.remove(at: index)
    }

}

extension PostListViewModel: PostListModelManagerProtocol {
    func dismiss(post: Post) {

        guard let index = postList?.posts.firstIndex(where: { $0 === post }) else {
            return
        }
        postList?.posts.remove(at: index)
        delegate?.postListViewModelDeleted(self, at: [IndexPath(item: index, section: 0)])
    }

    func dismissAll() {
        guard let postList = self.postList else { return }

        var allIndexes = [IndexPath]()

        for index in postList.posts.indices {
            allIndexes.append(IndexPath(item: index, section: 0))
        }
        postList.posts.removeAll()
        delegate?.postListViewModelDeleted(self, at: allIndexes)
    }

    func visit(_ post: Post) {
        post.visited = true
        delegate?.postListViewModelListUpdated(self)
    }

}
