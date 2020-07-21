//
//  String+Extensions.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

extension String {
  func createNameFromEmail() -> String {
    let email = self as NSString
    let range = email.range(of: "@")
    let location = range.location
    let name = email.substring(to: location)
    return name
  }
}
