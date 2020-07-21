//
//  SceneDelegate.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.windowScene = windowScene
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let _ = Auth.auth().currentUser {
      guard let bbqItemVC = storyboard.instantiateViewController(identifier: "BBQItemsViewController") as? BBQItemsViewController else {
        return
      }
      window?.rootViewController = UINavigationController(rootViewController: bbqItemVC)
    } else {
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      guard let loginVC = storyboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController else {
        return
      }
      window?.rootViewController = loginVC
    }
    window?.makeKeyAndVisible()
  }  
  
}

