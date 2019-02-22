//
//  ConversationsListViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 21/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
  let a : [String:Int] = ["Online":4, "History":3]
  @IBOutlet private var tableView: UITableView!
    override func viewDidLoad() {
      super.viewDidLoad()
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return a.keys.count
  }
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Online"
    default:
      return "History"
    }
  }
}
