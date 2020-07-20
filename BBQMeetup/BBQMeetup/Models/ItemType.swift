//
//  ItemType.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

enum ItemType: String, CaseIterable, Comparable {
  case seafood = "Seafood"
  case drink = "Drink"
  case meat = "Meat"
  case game = "Game"
  case dessert = "Dessert"
}

extension ItemType {
  static func <(lhs: ItemType, rhs: ItemType) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}
