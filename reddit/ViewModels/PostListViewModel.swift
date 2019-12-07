//
//  PostListViewModel.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import Foundation

protocol PostListViewModelDelegate: class {
    func postListViewModelLoadingUpdated(_ postListViewModel: PostListViewModel)
    func postListViewModelListUpdated(_ postListViewModel: PostListViewModel)
    func postListViewModel(_ postListViewModel: PostListViewModel, reportError: Error)
}

class PostListViewModel {

    private let reditService: RedditServiceProtocol

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

    init(reditService: RedditServiceProtocol) {
        self.reditService = reditService
    }

    func loadPosts() {
        loading = true
        reditService.top { [weak self] result in

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
