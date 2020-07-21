//
//  UIViewController+ResetWindow.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

extension UIViewController {
  private func resetWindow(with vc: UIViewController?) {
    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
      fatalError("could not get scene delegate ")
    }
    sceneDelegate.window?.rootViewController = vc
  }
  
  func showViewController(with id: String) {
    let vc = storyboard?.instantiateViewController(identifier: id)
    resetWindow(with: vc)
  }
}
