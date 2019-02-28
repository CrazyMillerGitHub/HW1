//
//  Logger.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class Logger {

  static let SharedInstance = Logger(isLogEnabled: false)
  private let isLogEnabled: Bool
  init(isLogEnabled: Bool) {
    self.isLogEnabled = isLogEnabled
  }

  func log(message: String) {
    guard isLogEnabled else { return }
    print(message)
  }
}
