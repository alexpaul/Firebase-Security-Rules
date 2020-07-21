//
//  AddItemViewController.swift
//  BBQMeetup
//
//  Created by Alex Paul on 7/19/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol AddItemViewControllerDelegate: AnyObject {
  func didAddItem(_ addItemViewController: AddItemViewController, item: Item)
}

class AddItemViewController: UIViewController {
  @IBOutlet weak var itemNameTextField: UITextField!
  @IBOutlet weak var pickerView: UIPickerView!
  
  weak var delegate: AddItemViewControllerDelegate?
  
  private var selectedItemType: ItemType?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pickerView.dataSource = self
    pickerView.delegate = self
    selectedItemType = ItemType.allCases.first
  }
    
  @IBAction func addItemToBBQList(_ sender: UIButton) {
    guard let user = Auth.auth().currentUser else {
      showAlert(title: "No Account Detected", message: "You need to be logged in to use this feature.") { action in
        self.dismiss(animated: true)
      }
      return
    }
    
    guard let itemName = itemNameTextField.text,
      !itemName.isEmpty,
      let selectedItemType = selectedItemType,
      let personName = user.displayName else {
        showAlert(title: "Missing Fields", message: "All fields are required.")
        return
    }
    let item = Item(itemId: UUID().uuidString,
                    name: itemName,
                    personId: user.uid,
                    personName: personName,
                    servings: 0,
                    type: selectedItemType.rawValue)
    delegate?.didAddItem(self, item: item)
    dismiss(animated: true)
  }
}

extension AddItemViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return ItemType.allCases.count
  }
}

extension AddItemViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return ItemType.allCases[row].rawValue
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedItemType = ItemType.allCases[row]
  }
}
