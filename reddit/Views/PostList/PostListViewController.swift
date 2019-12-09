//
//  PostListViewController.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 08/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var detailViewController: DetailViewController?

    var viewModel: PostListViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Redit Posts"

        buildRefreshControl()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125

        if let split = splitViewController {
            let controllers = split.viewControllers
            if let navigation = controllers[controllers.count-1] as? UINavigationController,
                let controller = navigation.topViewController as? DetailViewController {
                detailViewController = controller
            }
        }

        viewModel?.loadPosts()

    }

    @IBAction func dismissAllTap() {
        viewModel?.dismissAll()
    }

    @objc func refresh(sender: AnyObject) {
        viewModel?.loadPosts()
    }

    func buildRefreshControl() {
        if tableView.refreshControl == nil {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.tintColor = .lightGray
            tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let viewModel = self.viewModel,
                    let topController = (segue.destination as? UINavigationController)?.topViewController,
                    let detail = topController as? DetailViewController {

                    let post = viewModel.posts[indexPath.row]

                    let controller = detail
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    controller.viewModel = PostDetailViewModel(with: post, postListManager: viewModel)
                    detailViewController = controller
                }
            }
        }
    }

}

extension PostListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.posts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostListCell else {
            return UITableViewCell()
        }

        if let viewModel = viewModel {
            let post = viewModel.posts[indexPath.row]
            cell.viewModel = PostListCellViewModel(with: post,
                                                   postListManager: viewModel)
        }
        return cell
    }

}

extension PostListViewController: PostListViewModelDelegate {

    func postListViewModelLoadingUpdated(_ postListViewModel: PostListViewModel) {
        if !postListViewModel.loading {
            tableView.refreshControl?.endRefreshing()
        }
    }

    func postListViewModelListUpdated(_ postListViewModel: PostListViewModel) {
        tableView.reloadData()
    }

    func postListViewModel(_ postListViewModel: PostListViewModel, reportError: Error) {
        let alert = UIAlertController(title: "Something went wrong",
                                      message: reportError.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        present(alert, animated: true)
    }

    func postListViewModelDeleted(_ postListViewModel: PostListViewModel, at indexes: [IndexPath]) {
        tableView.deleteRows(at: indexes, with: .fade)
    }

}
