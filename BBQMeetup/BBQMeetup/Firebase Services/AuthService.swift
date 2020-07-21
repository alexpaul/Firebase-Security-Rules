//
//  AuthService.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
  
  private init() {}
  static let shared = AuthService() 
  
  func createUser(with email: String, and password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let user = Auth.auth().currentUser,
        let displayName = user.email?.createNameFromEmail() else {
        return
      }
      let changeRequest = user.createProfileChangeRequest()
      changeRequest.displayName = displayName
      changeRequest.commitChanges()
      
      let person = Person(name: displayName,
                          personId: UUID().uuidString,
                          email: email,
                          connection: "randomPerson")
      
      Firestore.firestore().collection(Collection.people).document(user.uid).setData(person.personDict) { (error) in
        if let error = error {
          completion(.failure(error))
          return
        }
        completion(.success(true))
      }
    }
  }
  
  func signInUser(with email: String, and password: String, completion: @escaping (Result<Bool, Error>) -> ()) {
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      completion(.success(true))
    }
  }
}
