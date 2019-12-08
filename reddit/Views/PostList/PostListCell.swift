//
//  PostListCell.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

class PostListCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numCommentLabel: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!

    var viewModel: PostListCellViewModel? {
        didSet {
            displayModelInfo()
        }
    }

    override func prepareForReuse() {
        thumbImage.image = nil
    }

    func displayModelInfo() {
        userLabel.text = viewModel?.author
        timeLabel.text = viewModel?.created
        titleLabel.text = viewModel?.title
        numCommentLabel.text = viewModel?.numComments

        if let thumbnailPath = viewModel?.thumbnail,
            let thumbnailUrl = URL(string: thumbnailPath) {
            thumbImage.load(url: thumbnailUrl)
        }

    }

}
