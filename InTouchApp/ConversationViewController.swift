//
//  ConversationViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
  var txt: String? {get set}
}
class ConversationViewController: UIViewController,UITextFieldDelegate,CommunicatorDelegate {
  func didFoundUser(userID: String, userName: String?) {
    tableView.reloadData()
  }
  
  func didLostUser(userID: String) {
    tableView.reloadData()
  }
  
  func failedToStartBrowsingForUsers(error: Error) {
    
  }
  
  func failedToStartAdvertising(error: Error) {
  }
  
  func didRecieveMessage(text: String, fromUser: String, toUser: String) {
    
  }
  
  var arr = ["Привет, серъезный вопрос...", "Привет, какой?", "Идём?", "Куда?", "Ты знаешь...", "Аааа, ок"]
  @IBOutlet weak var tableView: UITableView!
  var mpc = MultipeerCommunicator()
  @IBOutlet var textField: UITextField!
  @IBOutlet var searchView: UIView!
  @IBOutlet var bottomConstraint: NSLayoutConstraint!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = false
    extendedLayoutIncludesOpaqueBars = true
    tableView.delegate = self
    mpc.delegate = self
    textField.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .white
    NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardNotification(notification:)),name: UIResponder.keyboardWillShowNotification,object: nil)
    NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardNotification(notification:)),name: UIResponder.keyboardWillHideNotification,object: nil)
  }
  @objc func keyboardNotification(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
      self.bottomConstraint.constant = isKeyboardShowing ?  -keyboardFrame.cgRectValue.height : 0
      UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
        self.view.layoutIfNeeded()
      }) { (completed) in
      }
    }
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    textField.endEditing(true)
  }
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arr.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row % 2 == 0 {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CustomConversationCell1 else {
        return tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) }
      cell.config(text: arr[indexPath.row])
      return cell
    }
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomConversationCell2 else {
      return tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) }
    cell.config(text: arr[indexPath.row])
    return cell
  }
}
class CustomConversationCell1: UITableViewCell, MessageCellConfiguration {
  var txt: String?
  @IBOutlet weak var bgImage: UIImageView!
  @IBOutlet weak var inTextLabel: UILabel!
  func config(text: String) {
    self.backgroundColor = .clear
    self.txt = text
    inTextLabel.text = self.txt
    bgImage.tintColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.00)
    bgImage.image = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
  }
}

class CustomConversationCell2: UITableViewCell, MessageCellConfiguration {
  var txt: String?
  @IBOutlet weak var bgImage: UIImageView!
  @IBOutlet weak var outTextLabel: UILabel!
  func config(text: String) {
    self.backgroundColor = .clear
    self.txt = text
    outTextLabel.text = self.txt
    bgImage.image = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
  }
}
