//
//  ConversationsListViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 21/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!
    override func viewDidLoad() {
      super.viewDidLoad()
      extendedLayoutIncludesOpaqueBars = true
      self.title = "Tinkoff Chat"
      self.tableView.dataSource = self
      self.tableView.delegate = self
      self.tableView.tableFooterView = UIView()
  }
  override func viewDidAppear(_ animated: Bool) {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //Когда выбрана cell, subview меняет цвет на selectionColor. Можно пофиксить с помощью extension, но пока не большая проблема
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
    let arr = Users.sharedInstance.configureUsers()[indexPath.section][indexPath.row]
    let time = convertToDate(from: arr[2] as! String)
    if let online = arr[3], let unread = arr[4]  {
      cell.configureCell(name: arr[0] as! String, message: arr[1] as! String , date: time, online: online as! Bool, hasUnreadmessage: unread as! Bool)
    }
    return cell
  }
  private func convertToDate(from string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    guard let date = dateFormatter.date(from:string) else {
      return Date()
    }
    return date
  }
  override func viewWillAppear(_ animated: Bool) {
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Users.sharedInstance.configureUsers()[section].count
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
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
      guard let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row else{
        return
      }
      vc.arr.append(Users.sharedInstance.configureUsers()[section][row][1] as! String)
      vc.navigationItem.title = Users.sharedInstance.configureUsers()[section][row][0] as? String
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

//MARK: - TableCell
class TableCell: UITableViewCell,ConversationCellonfiguration {
  var name: String?
  
  var message: String?
  
  var date: Date?
  
  var online: Bool = false
  
  var hasUnreadMessage: Bool = false
  
  @IBOutlet private var onlineStatusView: UIView!
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var descriptionLabel: UILabel!
  @IBOutlet private var lastVisitDate: UILabel!
  
  private func rnd() -> CGFloat {
    return CGFloat.random(in: 0...100) / 100
  }
  func configureCell(name: String, message: String, date: Date, online: Bool, hasUnreadmessage: Bool) {
    
    self.name = name
    self.message = message
    self.online = online
    self.profileImage.backgroundColor = UIColor(red: rnd(), green:rnd(), blue:rnd(), alpha:1.00)
    self.profileImage.layer.cornerRadius = 31
    self.hasUnreadMessage = hasUnreadmessage
    self.date = date
    lastVisitDate.text = dateToString(from: self.date!)
    descriptionLabel.text = self.message
    onlineStatusView.layer.cornerRadius = 9
    titleLabel.text = name

    if self.message == "" {
      self.message = nil
      descriptionLabel.text = "No messages yet"
      self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .thin)
    }
    if self.online == true{
      self.onlineStatusView.backgroundColor = UIColor(red:0.43, green:1.00, blue:0.75, alpha:1.00)
      backgroundColor = UIColor(red:1.00, green:1.00, blue:0.82, alpha:1.00)
    }
    if self.hasUnreadMessage == true{
      self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    }
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    self.onlineStatusView.backgroundColor = .clear
    self.descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    self.backgroundColor = .white

  }
  private func dateToString(from date: Date)-> String {
    let calendar = NSCalendar.autoupdatingCurrent
    let components = calendar.dateComponents([.month, .day, .year], from: date, to: Date())
    let d_format = DateFormatter()
    if let day = components.day, let month = components.month, let year = components.year {
      if day + month + year > 0 {
        d_format.dateFormat = "dd MMM"
        return d_format.string(from: date)
      }
    }
    d_format.dateFormat = "HH:mm"
    return d_format.string(from: date)
  }
}
