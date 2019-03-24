//
//  StorageManager.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 24/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class StorageManager: NSObject {
  var coreDataStack = CoreDataStack()
  override init() {
    super.init()
    coreDataStack.delegate = self
  }
  static var Instance = StorageManager()
}
