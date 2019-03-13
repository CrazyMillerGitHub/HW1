//
//  GCDDataManager.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 11/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class GCDDataManager: NSObject {
  var delegate: ProfileViewControllerDelegate?
  var arr = [String: Any]()
  
  
  init(arr: [String: Any]){
    self.arr = arr
  }
  func save(){
    let group = DispatchGroup()
    let concurentQueue = DispatchQueue(label: "com.apple.queue",qos: .utility, attributes:.concurrent)
    //.enabled = false
    group.enter()
    concurentQueue.async {
      if let title = self.arr["title"] as? String {
        UserDefaults.standard.set(title, forKey: "profileLabel")
      }
      group.leave()
    }
    
    group.enter()
    concurentQueue.async {
      if let image = self.arr["image"] as? NSData {
        UserDefaults.standard.set(image, forKey: "imageView")
      }
      group.leave()
    }
    
    group.enter()
    concurentQueue.async {
      if let description = self.arr["description"] as? String {
        UserDefaults.standard.set(description, forKey: "descriptionLabel")
      }
      group.leave()
    }
    group.notify(queue: concurentQueue, execute: {
       self.delegate?.changeProileData(success: true)
    })
  }
}
