//
//  DetailViewController.swift
//  deviget
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var postDetailViewModel: PostDetailViewModel? {
        didSet {
            postDetailViewModel?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let post = postDetailViewModel?.post {
            detailDescriptionLabel.text = post.title
        }
    }

}

extension DetailViewController: PostDetailViewModelDelegate {

    func postDetailViewModelUpdated(_ postDetailViewModel: PostDetailViewModel) {
        configureView()
    }

}
