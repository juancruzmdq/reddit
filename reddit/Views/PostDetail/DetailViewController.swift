//
//  DetailViewController.swift
//  deviget
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!

    var viewModel: PostDetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.visit()
    }

    func configureView() {
        // Update the user interface for the detail item.
        userLabel.text = viewModel?.author
        titleLabel.text = viewModel?.title

        if let thumbnailPath = viewModel?.thumbnail,
                let thumbnailUrl = URL(string: thumbnailPath) {
                thumbImage.load(url: thumbnailUrl)
        } else {
            thumbImage.isHidden = true
        }
    }

}

extension DetailViewController: PostDetailViewModelDelegate {

    func postDetailViewModelUpdated(_ postDetailViewModel: PostDetailViewModel) {
        configureView()
    }

}
