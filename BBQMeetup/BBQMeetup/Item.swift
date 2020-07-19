//
//  Item.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

struct Item: Hashable {
  let itemId: String
  let name: String
  let personId: String
  let servings: Int
  let type: String
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(itemId)
    hasher.combine(personId)
  }
}

// tradional way in Firebase
extension Item {
  // tradional way in Firebase
  init?(dict: [String: Any]) {
    guard let itemId = dict["itemId"] as? String,
      let name = dict["name"] as? String,
      let personId = dict["personId"] as? String,
      let servings = dict["servings"] as? Int,
      let type = dict["type"] as? String else {
        return nil
    }
    self.itemId = itemId
    self.name = name
    self.personId = personId
    self.servings = servings
    self.type = type
  }
}

extension Item {
  var itemDict: [String: Any] {
    ["name": name,
     "personId": personId,
     "servings": servings,
     "itemId": itemId,
     "type": type
    ]
  }
}
