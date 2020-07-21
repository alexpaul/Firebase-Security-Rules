//
//  UIViewController+Alerts.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(title: String?, message: String?, action: ((UIAlertAction) -> ())? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: action)
    alertController.addAction(okAction)
    present(alertController, animated: true)
  }
}
