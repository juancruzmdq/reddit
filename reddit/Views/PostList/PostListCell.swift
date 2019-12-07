//
//  PostListCell.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 07/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

class PostListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    var viewModel: PostListCellViewModel? {
        didSet {
            self.displayModelInfo()
        }
    }

    func displayModelInfo() {
        self.titleLabel.text = viewModel?.title
    }

}
