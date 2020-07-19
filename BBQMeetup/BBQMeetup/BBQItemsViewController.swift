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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let addItemVC = segue.destination as? AddItemViewController else {
      fatalError("could not segue to AddItemViewController")
    }
    addItemVC.delegate = self
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
      cell.detailTextLabel?.text = "Person bringing item: \(item.personId)"
      return cell
    })
    dataSource.defaultRowAnimation = .fade
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

extension BBQItemsViewController: AddItemViewControllerDelegate {
  func didAddItem(_ addItemViewController: AddItemViewController, item: Item) {
    guard let itemType = ItemType(rawValue: item.type) else {
      return
    }
    DatabaseService.shared.addItem(item: item) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .failure(let error):
        print(error)
      case .success:
        var snapshot = self.dataSource.snapshot()
        snapshot.appendItems([item], toSection: itemType)
        self.dataSource.apply(snapshot, animatingDifferences: true)
      }
    }
  }
}
