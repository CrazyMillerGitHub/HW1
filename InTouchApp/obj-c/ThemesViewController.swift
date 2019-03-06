//
//  ThemesViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 06/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
  var model = Themes()
  var listController = ConversationsListViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
      // Do any additional setup after loading the view.
    }
  @IBAction func returnButton(_ sender: Any) {
      self.dismiss(animated: true, completion: nil)
  }
  @IBAction func firstThemeButton(_ sender: Any) {
    self.view.backgroundColor = model.theme1
    self.listController.logThemeChanging(selectedTheme: model.theme1)
  }
  @IBAction func secondThemeButton(_ sender: Any) {
    self.view.backgroundColor = model.theme2
    self.listController.logThemeChanging(selectedTheme: model.theme2)
  }
  @IBAction func thirdThemeButton(_ sender: Any) {
    self.view.backgroundColor = model.theme3
    self.listController.logThemeChanging(selectedTheme: model.theme3)
  }
}
