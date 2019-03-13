//
//  OperationDataManager.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 12/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
class OperationDataManager: NSObject {
  var delegate: ProfileViewControllerDelegate?
  var titleLabel: String
  var editTitle: String
  var dscr: String
  var editedDescription: String
  var imageView: NSData
  var image: Bool = false
  var title: Bool = false
  var descriptionText: Bool = false
  static var userInstance = OperationDataManager(titleLabel: "", description: "", editedDescription: "", imageView: NSData(), editTitle: "")
  init(titleLabel: String, description: String,editedDescription: String, imageView: NSData,editTitle: String) {
    self.titleLabel = titleLabel
    self.editTitle = editTitle
    self.editedDescription = editedDescription
    self.dscr = description
    self.imageView = imageView
  }
 
  func apply(){
    let printerQueue =  OperationQueue()
    let image = EditImage(image: imageView)
    let title = EditTitle(titleLabel: titleLabel, editTitle: editTitle)
    let dscrTitle = EditDescription(dscr: dscr, editedDescription: editedDescription)
    let notify = Notify()
    notify.addDependency(image)
    notify.addDependency(title)
    notify.addDependency(dscrTitle)
    printerQueue.addOperation(image)
    printerQueue.addOperation(title)
    printerQueue.addOperation(dscrTitle)
    printerQueue.addOperation(notify)
    printerQueue.waitUntilAllOperationsAreFinished()
    self.delegate?.changeProileData(image: true, title: true, descriptionText: true)
    
  }
  
  class EditImage: Operation {
    var image: NSData
    init(image: NSData) {
      self.image = image
    }
    override func main()  {
       UserDefaults.standard.set(self.image, forKey: "imageView")
    }
  }
  class EditTitle: Operation {
    var titleLabel: String
    var editTitle: String
    init(titleLabel: String,editTitle: String) {
      self.titleLabel = titleLabel
      self.editTitle = editTitle
    }
    override func main()  {
      if editTitle != titleLabel {
         UserDefaults.standard.set(self.editTitle, forKey: "profileLabel")
      }
    }
  }
  class EditDescription: Operation {
    var dscr: String
    var editedDescription: String
    init(dscr: String,editedDescription: String) {
      self.dscr = dscr
      self.editedDescription = editedDescription
    }
    override func main()  {
      if dscr != editedDescription {
         UserDefaults.standard.set(self.editedDescription, forKey: "descriptionLabel")
      }
    }
  }
  
  
}
  class Notify: Operation {
    override func main() {
      print("Done")
    
    }
  }
