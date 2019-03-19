//
//  ConversationsListViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 21/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class ConversationsListViewController: UIViewController,dataDelegate {
  func reloadData(status: Bool) {
    if status == true {
      tableView.reloadData()
    }
  }
  
 
 
 
//   var mpc = MultipeerCommunicator()
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

//MARK:- Закоментить extension, если ThemesViewController - swift file
extension ConversationsListViewController: ThemesViewControllerDelegate {
  func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
    logThemeChanging(selectedTheme: selectedTheme)
  }
}
var peer = ""
var info = ""
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //Когда выбрана cell, subview меняет цвет на selectionColor. Можно пофиксить с помощью extension, но пока не большая проблема
    // swiftlint:disable force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    let arr = Users.sharedInstance.configureUsers()[indexPath.section][indexPath.row]
    let time = convertToDate(from: arr[2] as! String)
    info = CommunicatorManager.Instance.arr[indexPath.row]
    peer = CommunicatorManager.Instance.peers[indexPath.row]
    if let online = arr[3], let unread = arr[4] {
      cell.configureCell(name: info, message: arr[1] as! String, date: time, online: online as! Bool, hasUnreadmessage: unread as! Bool)
      // swiftlint:enable force_cast
    }
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
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     print(CommunicatorManager.Instance.arr.count)
     return CommunicatorManager.Instance.arr.count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    switch section {
//    case 0:
//      return "Online"
//    default:
//      return "History"
//    }
//  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueIndentifier" {
      guard let destinationViewController = segue.destination as? ConversationViewController else { return }
      guard let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row else { return }
      guard let value = Users.sharedInstance.configureUsers()[section][row][1] as? String else { return }
      destinationViewController.arr.append(value)
      destinationViewController.peer[info] = peer
      destinationViewController.navigationItem.title = Users.sharedInstance.configureUsers()[section][row][0] as? String
    }else if segue.identifier == "kek"{
      let vc = segue.destination as! UINavigationController
      let d = vc.topViewController as! ThemesViewController
      d.model = Themes()
      d.delegate = self
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
