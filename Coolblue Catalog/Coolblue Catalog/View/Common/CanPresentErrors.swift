//
//  CanPresentErrors.swift
//  Coolblue Catalog
//
//  Created by Roman Churkin on 18.05.2022.
//

import UIKit

// CanPresentErrors protocol
///
/// For objects that can display errors to user
protocol CanPresentErrors {

    /// Please, present this error `message`
    ///
    /// You should call this on a main thread.
    @MainActor func showError(_ error: Error)

}

extension CanPresentErrors where Self: UIViewController {

    func showError(_ error: Error) {
        let message: String
        switch error {
        case let error as URLError:
            if error.code == .cancelled {
                return
            } else {
                message = error.localizedDescription
            }
        case let error as NSError:
            message = error.localizedDescription
        }

        let alert = UIAlertController(title: "Error occurred", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true)
    }

}

