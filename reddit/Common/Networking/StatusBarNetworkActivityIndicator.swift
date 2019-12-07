//
//  StatusBarNetworkActivityIndicator.swift
//
//  Created by Juan Cruz Ghigliani on 8/5/18.
//

import UIKit

class StatusBarNetworkActivityIndicator: NetworkActivityIndicatorProtocol {

    var activeNetworkProcess = 0

    func startNetworkActivity() {
        // if is the first process notify the user that there are some network activity in progress
        if activeNetworkProcess == 0 {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }

        // register a new process
        activeNetworkProcess += 1
    }

    func finishNetworkActivity() {
        // if there are active process register that one of them has finished
        if activeNetworkProcess > 0 {
            activeNetworkProcess -= 1
        }

        // if there are no more active process notify th user that the network activity has finishes
        if activeNetworkProcess == 0 {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
