//
//  DatabaseService.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Collection {
  static let items = "items"
}

class DatabaseService {
  
  private init() {}
  static let shared = DatabaseService()
  
  func deleteItem(item: Item, completion: @escaping (Result<Bool, Error>) -> ()) {
    Firestore.firestore().collection(Collection.items).document(item.itemId).delete { (error) in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(true))
      }
    }
  }
}
