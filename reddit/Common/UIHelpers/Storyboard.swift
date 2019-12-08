//
//  Storyboard.swift
//
//  Created by Juan Cruz Ghigliani on 5/5/18.
//

import UIKit

protocol Storyboard {
    func storyboard(in bundle: Bundle?) -> UIStoryboard?
    func initialViewController<T: UIViewController>(in bundle: Bundle?) -> T?
}

extension Storyboard where Self: RawRepresentable {

    func storyboard(in bundle: Bundle? = nil) -> UIStoryboard? {
        return UIStoryboard(name: "\(self.rawValue)", bundle: bundle)
    }

    func initialViewController<T: UIViewController>(in bundle: Bundle? = nil) -> T? {
        let storyboard = self.storyboard(in: bundle)
        return storyboard?.instantiateInitialViewController() as? T
    }

}
