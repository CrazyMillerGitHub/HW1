//
//  ConversationsListViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 21/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class ConversationsListViewController: UIViewController, dataDelegate {
  func reloadData(status: Bool) {
    if status == true {
      DispatchQueue.main.async {
         self.tableView.reloadData()
      }
    }
  }
  @IBOutlet private var tableView: UITableView!
    override func viewDidLoad() {
      super.viewDidLoad()
      extendedLayoutIncludesOpaqueBars = true
      self.tableView.dataSource = self
      self.tableView.delegate = self
      CommunicatorManager.Instance.delegate = self
      CommunicatorManager.Instance.communicator.advertiser.startAdvertisingPeer()
     CommunicatorManager.Instance.communicator.browser.startBrowsingForPeers()
  }
  override func viewDidAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }
}

// MARK: - Закоментить extension, если ThemesViewController - swift file
extension ConversationsListViewController: ThemesViewControllerDelegate {
  func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
    logThemeChanging(selectedTheme: selectedTheme)
  }
}
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //Когда выбрана cell, subview меняет цвет на selectionColor. Можно пофиксить с помощью extension, но пока не большая проблема
    // swiftlint:disable force_cast
    CommunicatorManager.Instance.users.sort { (name1, name2) -> Bool in
      var time1 = Date()
      var time2 = Date()
      if let time = CommunicatorManager.Instance.communicator.message[name1.peerID]?.last?.date {
        time1 = time
      }
      if let time = CommunicatorManager.Instance.communicator.message[name2.peerID]?.last?.date {
        time2 = time
      }
      return time1 > time2
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
//    let arr = Users.sharedInstance.configureUsers()[indexPath.section][indexPath.row]
    var messageTime = Date()
    var message = ""
    if let lastMessage = CommunicatorManager.Instance.communicator.message[CommunicatorManager.Instance.users[indexPath.row].peerID] {
      print(message)
      message = (lastMessage.last?.message)!
      messageTime = (lastMessage.last?.date)!
    }
      cell.configureCell(name: CommunicatorManager.Instance.users[indexPath.row].username, message: message, date: messageTime, online: true, hasUnreadmessage: true)
      // swiftlint:enable force_cast
    return cell
  }
  private func convertToDate(from string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    guard let date = dateFormatter.date(from: string) else {
      return Date()
    }
    return date
  }
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return CommunicatorManager.Instance.users.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueIndentifier" {
      guard let destinationViewController = segue.destination as? ConversationViewController else { return }
      guard let _ = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row else { return }
      destinationViewController.userData.peerID = CommunicatorManager.Instance.users[row].peerID
      destinationViewController.userData.userName = CommunicatorManager.Instance.users[row].username
      print(destinationViewController.userData)
      destinationViewController.navigationItem.title = CommunicatorManager.Instance.users[row].username
    } else if segue.identifier == "themeSegueIdentifier"{
       // swiftlint:disable force_cast
      let navigationViewController = segue.destination as! UINavigationController
      let segueViewController = navigationViewController.topViewController as! ThemesViewController
       // swiftlint:enable force_cast
      segueViewController.model = Themes()
      segueViewController.delegate = self
    }
  }
  func logThemeChanging(selectedTheme: UIColor) {
    switch selectedTheme {
    case .white:
      if let selectedTheme = Theme(rawValue: 0) {
        selectedTheme.apply()
      }
    case .black:
      if let selectedTheme = Theme(rawValue: 1) {
        selectedTheme.apply()
      }
    default:
      if let selectedTheme = Theme(rawValue: 2) {
        selectedTheme.apply()
      }
    }
  }
}
protocol ConversationCellonfiguration: class {
  var name: String? {get set}
  var message: String? {get set}
  var date: Date? {get set}
  var online: Bool {get set}
  var hasUnreadMessage: Bool {get set}
}
