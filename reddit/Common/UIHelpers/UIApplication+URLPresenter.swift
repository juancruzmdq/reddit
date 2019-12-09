//
//  UIApplication+URLPresenter.swift
//  reddit
//
//  Created by Juan Cruz Ghigliani on 09/12/2019.
//  Copyright © 2019 Juan Cruz Ghigliani. All rights reserved.
//

import UIKit

protocol URLPresenterProtocol {
    func open(_ url: URL,
              options: [UIApplication.OpenExternalURLOptionsKey: Any],
              completionHandler completion: ((Bool) -> Void)?)
}

extension UIApplication: URLPresenterProtocol {}
