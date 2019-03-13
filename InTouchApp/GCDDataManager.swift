//
//  GCDDataManager.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 11/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class GCDDataManager: NSObject {
  var titleLabel: String
  var dscr: String
  var editedDescription: String
  var imageView: NSData
  var delegate: ProfileViewControllerDelegate?
  var editTitle: String
  var image: Bool = false
  var title: Bool = false
  var descriptionText: Bool = false
  
  
  init(titleLabel: String, description: String,editedDescription: String, imageView: NSData,editTitle: String) {
    self.titleLabel = titleLabel
    self.editTitle = editTitle
    self.editedDescription = editedDescription
    self.dscr = description
    self.imageView = imageView
  }
  func save(){
    let group = DispatchGroup()
    let concurentQueue = DispatchQueue(label: "com.apple.queue",qos: .utility, attributes:.concurrent)
    //.enabled = false
    group.enter()
    concurentQueue.async {
      if self.titleLabel != self.editTitle {
        UserDefaults.standard.set(self.editTitle, forKey: "profileLabel")
        self.title = true
      }
      group.leave()
    }
    
    group.enter()
    concurentQueue.async {
      if 1 == 1 {
        UserDefaults.standard.set(self.imageView, forKey: "imageView")
        self.image = true
      }
      group.leave()
    }
    
    group.enter()
    concurentQueue.async {
    if self.editedDescription != self.dscr {
        UserDefaults.standard.set(self.editedDescription, forKey: "descriptionLabel")
      self.descriptionText = true
      }
      group.leave()
    }
    group.notify(queue: concurentQueue, execute: {
      self.delegate?.changeProileData(image: self.image, title: self.title, descriptionText: self.descriptionText)
    })
  }
}
