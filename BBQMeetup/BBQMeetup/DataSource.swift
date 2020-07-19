//
//  DataSource.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class DataSource: UITableViewDiffableDataSource<ItemType, Item> {
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ItemType.allCases[section].rawValue
  }
}
