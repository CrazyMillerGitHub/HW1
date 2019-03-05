//
//  Theme.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 05/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit

enum Theme: Int {
  //1
  case light, dark, champagne
  //2
  private enum Keys {
    static let selectedTheme = "SelectedTheme"
  }
  //3
  static var current: Theme {
    let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
    return Theme(rawValue: storedTheme) ?? .light
  }
var mainColor: UIColor {
  switch self {
  case .light:
    return UIColor.black
  case .dark:
    return UIColor.white
  case .champagne:
    return UIColor.black
  }
  }
var barStyle: UIColor {
  switch self {
  case .light:
    return UIColor.white
  case .dark:
    return UIColor.black
  default:
    return UIColor(red:0.90, green:0.83, blue:0.72, alpha:1.00)
  }
}
func apply() {
  UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
  UserDefaults.standard.synchronize()
  UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor]
  UINavigationBar.appearance().tintColor = mainColor
  UINavigationBar.appearance().barTintColor = barStyle
}
}
