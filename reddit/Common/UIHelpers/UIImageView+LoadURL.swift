//
//  UIImageView+LoadFromURL.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 08/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.setNeedsLayout()
                    }
                }
            }
        }
    }
}
