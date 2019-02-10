//
//  Logging.swift
//  HW
//
//  Created by Михаил Борисов on 10/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

var Log = Logging()

struct StruckOfLog {
  static var isLogging = false
}

class Logging: NSObject {
  func check(_ message: String){
    if StruckOfLog.isLogging == true {
      return print(message)
    }
  }
}
