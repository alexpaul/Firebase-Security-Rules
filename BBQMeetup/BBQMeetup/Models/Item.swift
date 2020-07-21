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
  let personName: String
  let servings: Int
  let type: String
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(itemId)
    hasher.combine(personId)
  }
}

extension Item {
  init?(dict: [String: Any]) {
    guard let itemId = dict["itemId"] as? String,
      let name = dict["name"] as? String,
      let personId = dict["personId"] as? String,
      let personName = dict["personName"] as? String,
      let servings = dict["servings"] as? Int,
      let type = dict["type"] as? String else {
        return nil
    }
    self.itemId = itemId
    self.name = name
    self.personId = personId
    self.personName = personName
    self.servings = servings
    self.type = type
  }
}

extension Item {
  var itemDict: [String: Any] {
    ["name": name,
     "personId": personId,
     "personName": personName, 
     "servings": servings,
     "itemId": itemId,
     "type": type
    ]
  }
}
