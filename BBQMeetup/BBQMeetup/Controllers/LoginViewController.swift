//
//  ViewController.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBAction func signUp(_ sender: UIButton) {
    let email = validateEmailAndPassword().email
    let password = validateEmailAndPassword().password
    if validateEmailAndPassword().succes {
      AuthService.shared.createUser(with: email, and: password) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print(error)
        case .success:
          print("new user created")
          self?.showViewController(with: "BBQNavController")
        }
      }
    }
  }
  
  @IBAction func signIn(_ sender: UIButton) {
    let email = validateEmailAndPassword().email
    let password = validateEmailAndPassword().password
    if validateEmailAndPassword().succes {
      AuthService.shared.signInUser(with: email, and: password) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print(error)
        case .success:
          print("new user created")
          self?.showViewController(with: "BBQNavController")
        }
      }
    }
  }
  
  @IBAction func explore(_ sender: UIButton) {
    showViewController(with: "BBQNavController")
  }
  
  private func validateEmailAndPassword() -> (succes: Bool, email: String, password: String) {
    guard let email = emailTextField.text,
      !email.isEmpty,
      let password = passwordTextField.text,
      !password.isEmpty else {
        print("missing fields")
        return (false, "", "")
    }
    return (true, email, password)
  }
}

