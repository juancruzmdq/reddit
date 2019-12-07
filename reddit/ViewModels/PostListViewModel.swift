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
            self.delegate?.postListViewModelListUpdated(self)
        }
    }

    var loading: Bool = false {
        didSet {
            self.delegate?.postListViewModelLoadingUpdated(self)
        }
    }

    var posts: [Post] {
        self.postList?.posts ?? []
    }

    init(reditService: RedditServiceProtocol) {
        self.reditService = reditService
    }

    func loadPosts() {
        self.loading = true
        self.reditService.top { result in
            self.loading = false

            switch result {
            case let .success(postList):
                self.postList = postList
            case let .failure(error):
                self.delegate?.postListViewModel(self, reportError: error)
            }
        }
    }

    func remove(at index: Int) {
        self.postList?.posts.remove(at: index)
    }

}
