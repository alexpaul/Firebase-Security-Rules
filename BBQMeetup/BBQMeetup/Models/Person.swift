//
//  Person.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

struct Person {
  let name: String
  let personId: String
  let email: String
  let connection: String
}

extension Person {
  init?(dict: [String: Any]) {
    guard let name = dict["name"] as? String,
      let personId = dict["personId"] as? String,
      let email = dict["email"] as? String,
      let connection = dict["connection"] as? String else {
        return nil
    }
    self.name = name
    self.personId = personId
    self.email = email
    self.connection = connection
  }
}

extension Person {
  var personDict: [String: Any] {
    return [
      "name": name,
      "personId": personId,
      "email": email,
      "connection": connection
    ]
  }
}
