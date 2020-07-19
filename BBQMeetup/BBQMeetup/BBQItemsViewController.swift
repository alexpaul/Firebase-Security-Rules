//
//  BBQItemsViewController.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseFirestore

class BBQItemsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  private var dataSource: DataSource!

  override func viewDidAppear(_ animated: Bool) {
    configureDataSource()
    fetchItems()
  }
  
  private func fetchItems() {
    Firestore.firestore().collection(Collection.items).addSnapshotListener { [weak self] (querySnapshot, error) in
      if let error = error {
        print(error)
      } else if let querySnapshot = querySnapshot {
        self?.updateUI(querySnapshot: querySnapshot)
      }
    }
  }
  
  private func configureDataSource() {
    dataSource = DataSource(tableView: tableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
      cell.textLabel?.text = item.name
      return cell
    })
    
    var snapshot = NSDiffableDataSourceSnapshot<ItemType, Item>()
    for type in ItemType.allCases {
      snapshot.appendSections([type])
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  private func updateUI(querySnapshot: QuerySnapshot) {
    let itemsCollection = querySnapshot.documents.compactMap { Item(dict: $0.data()) }
    var snapshot = dataSource.snapshot()
    for type in ItemType.allCases {
      snapshot.deleteSections([type])
      snapshot.appendSections([type])
      let items = itemsCollection.filter { $0.type == type.rawValue }
      snapshot.appendItems(items, toSection: type)
    }
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
}