//
//  ConversationViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
  var text: String? {get set}
}
class MessageCel: MessageCellConfiguration {
  var text: String?
  init(text: String) {
    self.text = text
  }
}
class ConversationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
      extendedLayoutIncludesOpaqueBars = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
