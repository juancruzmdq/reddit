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

    var URLPresenter: URLPresenterProtocol?

    var viewModel: PostDetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addTapGestureToImage()
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

    func addTapGestureToImage() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(DetailViewController.thumbImageTap(gesture:)))

        thumbImage.addGestureRecognizer(tapGesture)
        thumbImage.isUserInteractionEnabled = true
    }

    @IBAction func thumbImageTap(gesture: UIGestureRecognizer) {
        if let urlString = viewModel?.thumbnail,
            let url = URL(string: urlString) {
            URLPresenter?.open(url, options: [:], completionHandler: nil)
        }
    }

}

extension DetailViewController: PostDetailViewModelDelegate {

    func postDetailViewModelUpdated(_ postDetailViewModel: PostDetailViewModel) {
        configureView()
    }

}
