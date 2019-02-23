//
//  ConversationsListViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 21/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
  var count = 4
  @IBOutlet private var tableView: UITableView!
    override func viewDidLoad() {
      super.viewDidLoad()
      
      extendedLayoutIncludesOpaqueBars = true
      self.title = "Tinkoff Chat"
      navigationController?.navigationBar.prefersLargeTitles = true
      self.tableView.dataSource = self
      self.tableView.delegate = self
      self.tableView.tableFooterView = UIView()
      // Do any additional setup after loading the view.
  }
}
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
    cell.configureCell(arr: Users.sharedInstance.configureUsers()[0][indexPath.row])
    
    return cell
  }
  
  override func viewWillAppear(_ animated: Bool) {
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Users.sharedInstance.configureUsers()[section].count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Online"
    default:
      return "History"
    }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueIndentifier" {
      let vc = segue.destination as! ConversationViewController
      guard let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.section else{
        return
      }
      print(Users.sharedInstance.configureUsers()[section][row])
      vc.navigationItem.title = Users.sharedInstance.configureUsers()[section][row][0] as! String
    }
  }
  
}
protocol ConversationCellonfiguration: class{
  var name: String? {get set}
  var message : String? {get set}
  var date: Date? {get set}
  var online: Bool {get set}
  var hasUnreadMessage: Bool {get set}
}


class TableCell: UITableViewCell {
  var delegate: ConversationCellonfiguration?
  @IBOutlet private var onlineStatusView: UIView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var lastVisitDate: UILabel!
  
  func configureCell(arr:[Any?]) {
    onlineStatusView.layer.cornerRadius = 6
    titleLabel.text = arr[0] as? String
    let d_format = DateFormatter()
    d_format.dateFormat = "HH:mm"
    descriptionLabel.text = arr[1] as? String
    let date = Date()
    lastVisitDate.text = d_format.string(from: date)
    if arr[3] as! Bool == true{
      self.onlineStatusView.backgroundColor = UIColor(red:0.43, green:1.00, blue:0.75, alpha:1.00)
    }
    if arr[4] as! Bool == true{
      self.descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
  }
  
}
