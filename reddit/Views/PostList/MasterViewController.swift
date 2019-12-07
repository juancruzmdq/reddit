//
//  MasterViewController.swift
//  deviget
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController?

    var viewModel: PostListViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

        viewModel?.loadPosts()

        if let split = splitViewController {
            let controllers = split.viewControllers
            if let navigation = controllers[controllers.count-1] as? UINavigationController,
                let controller = navigation.topViewController as? DetailViewController {
                detailViewController = controller
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc func refresh(sender: AnyObject) {
        viewModel?.loadPosts()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let post = viewModel?.posts[indexPath.row],
                    let topController = (segue.destination as? UINavigationController)?.topViewController,
                    let detail = topController as? DetailViewController {

                    let controller = detail
                    controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                    detailViewController = controller
                    detailViewController?.viewModel = PostDetailViewModel(with: post)

                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.posts.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostListCell else {
            return UITableViewCell()
        }

        if let post = viewModel?.posts[indexPath.row] {
            cell.viewModel = PostListCellViewModel(with: post)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension MasterViewController: PostListViewModelDelegate {

    func postListViewModelLoadingUpdated(_ postListViewModel: PostListViewModel) {
        if !postListViewModel.loading {
            refreshControl?.endRefreshing()
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

}
