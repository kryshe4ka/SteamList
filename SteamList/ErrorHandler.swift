//
//  ErrorHandler.swift
//  SteamList
//
//  Created by Liza Kryshkovskaya on 17.01.22.
//

import Foundation
import UIKit

class ErrorHandler {
    static func showErrorAlert(with message: String, presenter: UIViewController) {
        let alertController = UIAlertController(title: "Something went wrong", message: message, preferredStyle: .alert)
        let cancelAlertAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertController.addAction(cancelAlertAction)
        presenter.present(alertController, animated: true, completion: nil)
    }
}
