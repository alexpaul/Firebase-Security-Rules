//
//  FirebaseAuthenticationTests.swift
//  BBQMeetupTests
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
import FirebaseAuth

class FirebaseAuthenticationTests: XCTestCase {
  
  func testCreateAuthUser() {
    // arrange
    let email = getRandomEmail()
    let password = "123456"
    let exp = XCTestExpectation(description: "auth user created")
    // act
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      // assert
      exp.fulfill()
      if let error = error {
        XCTFail("failed to create user with error: \(error.localizedDescription)")
      }
      XCTAssertEqual(authDataResult?.user.email, email)
    }
    wait(for: [exp], timeout: 3.0)
  }
  
  private func getRandomEmail() -> String {
    let randomLength = Int.random(in: 5...10)
    let domains = ["gmail", "appple", "pursuit", "yahoo", "test", "hotmail"]
    let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyz1234567890".map { String($0) }
    var name = ""
    for _ in 0..<randomLength {
      name.append(lettersAndNumbers.randomElement() ?? "")
    }
    return "\(name)@\(domains.randomElement()!).com"
  }
  
  func testSignOutUser() {
    do {
      try Auth.auth().signOut()
      XCTAssert(true)
    } catch {
      XCTFail("failed to sign out user with error: \(error.localizedDescription)")
    }
  }
  
  func testSignInUser() {
    // arrange
    let email = "1r5dn@hotmail.com"
    let password = "123456"
    let exp = XCTestExpectation(description: "did sign in user")
    // act
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
      exp.fulfill()
      // assert
      if let error = error {
        XCTFail("failed to sign in user with error: \(error.localizedDescription)")
      }
      XCTAssertEqual(email, authDataResult?.user.email)
    }
    wait(for: [exp], timeout: 3.0)
  }
  
}
