//
//  FirebaseFirestoreTests.swift
//  BBQMeetupTests
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
import FirebaseAuth
import FirebaseFirestore
@testable import BBQMeetup

class FirebaseFirestoreTests: XCTestCase {
  
  func testCreatePersonInPeopleCollection() {
    // arrange
    let nameEmail = getRandomEmail()
    let password = "123456"
    let exp = XCTestExpectation(description: "auth user created")
    let collectionName = "people"
    let personId = UUID().uuidString
    let personDict: [String: Any] = ["name": nameEmail.name,
                                     "connection": getRandomEmail().name,
                                     "personId": personId,
                                     "email": nameEmail.email
    ]
    // act
    Auth.auth().createUser(withEmail: nameEmail.email, password: password) { (authDataResult, error) in
      if let error = error {
        XCTFail("failed to create auth user with error: \(error.localizedDescription)")
      }
      
      guard let user = Auth.auth().currentUser else {
        XCTFail("failed to locate current user")
        return
      }
      
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = nameEmail.name
      changeRequest.commitChanges()
      
      Firestore.firestore().collection(collectionName).document(personId).setData(personDict) { (error) in
        exp.fulfill()
        if let error = error {
          XCTFail("failed to create person in people collection with error: \(error.localizedDescription)")
        }
        XCTAssert(true)
      }
    }
    wait(for: [exp], timeout: 5.0)
  }
  
  private func getRandomEmail() -> (name: String, email: String) {
    let randomLength = Int.random(in: 5...10)
    let domains = ["gmail", "appple", "pursuit", "yahoo", "test", "hotmail"]
    let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyz1234567890".map { String($0) }
    var name = ""
    for _ in 0..<randomLength {
      name.append(lettersAndNumbers.randomElement() ?? "")
    }
    return (name, "\(name)@\(domains.randomElement()!).com")
  }
  
  func testAddItemForLoggedInUser() {
    // arrange
    let collectionName = "items"
    let exp = XCTestExpectation(description: "item added")
    guard let user = Auth.auth().currentUser else { return }
    let itemId = UUID().uuidString
    let itemDict: [String: Any] = ["name": "Dominoes",
                                   "type": ItemType.game.rawValue,
                                   "personId": user.uid,
                                   "servings": 4,
                                   "itemId": itemId
    ]
    // act
    Firestore.firestore().collection(collectionName).document(itemId).setData(itemDict) { (error) in
      // assert
      exp.fulfill()
      if let error = error {
        XCTFail("failed to add item with error: \(error.localizedDescription)")
      }
      XCTAssert(true)
    }
    wait(for: [exp], timeout: 3.0)
  }
  
}
