//
//  ConversationViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration:class {
  var txt : String? {get set}
}
class ConversationViewController: UIViewController {
  var arr = ["Привет, серъезный вопрос...", "Привет, какой?", "Идём?", "Куда?", "Ты знаешь...", "Аааа, ок"]
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.prefersLargeTitles = false
    extendedLayoutIncludesOpaqueBars = true
    tableView.delegate = self
    tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arr.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row % 2 == 0
    {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CustomConversationCell1
      cell.config(text: arr[indexPath.row])
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CustomConversationCell2
    cell.config(text: arr[indexPath.row])
    return cell
  }
}
class CustomConversationCell1: UITableViewCell,MessageCellConfiguration{
  var txt: String?
  @IBOutlet weak var bgImage: UIImageView!
  @IBOutlet weak var inTextLabel: UILabel!
  func config(text: String){
    self.txt = text
    inTextLabel.text = self.txt
    bgImage.tintColor = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.00)
    bgImage.image = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
  }
}
class CustomConversationCell2: UITableViewCell,MessageCellConfiguration{
  var txt: String?
  @IBOutlet weak var bgImage: UIImageView!
  @IBOutlet weak var outTextLabel: UILabel!
  func config(text: String){
    
    self.txt = text
    outTextLabel.text = self.txt
    bgImage.image = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
 
  }
}
