//
//  Logging.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit


struct StruckOfLog {
  static var isLogging = false
}

final class Logging: NSObject {
  var isLogging: Bool?
 
  static let shared = Logging()
  func check(_ message: String){
    if StruckOfLog.isLogging == true {
      return print(message)
    }
  }
}
