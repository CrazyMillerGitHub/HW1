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
  var arr = [String: Any]()
  init(arr: [String: Any]) {
   self.arr = arr
  }
 
  func apply(){
    let printerQueue =  OperationQueue()
    let notify = Notify()
    if let image = self.arr["image"] as? NSData {
      let img = EditImage(image: image)
       printerQueue.addOperation(img)
    }
    if let title = self.arr["title"] as? String {
      let ttl = EditTitle(titleLabel: title)
      printerQueue.addOperation(ttl)
    }
  if let description = self.arr["description"] as? String {
      let dscr = EditDescription(dscr: description)
      printerQueue.addOperation(dscr)
    }
    printerQueue.addOperation(notify)
    printerQueue.waitUntilAllOperationsAreFinished()
    self.delegate?.changeProileData(success: true)
    
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
    init(titleLabel: String) {
      self.titleLabel = titleLabel
    }
    override func main()  {
         UserDefaults.standard.set(self.titleLabel, forKey: "profileLabel")
    }
  }
  class EditDescription: Operation {
    var dscr: String
    init(dscr: String) {
      self.dscr = dscr
    }
    override func main()  {
         UserDefaults.standard.set(self.dscr, forKey: "descriptionLabel")
    }
  }
  
  
}
  class Notify: Operation {
    override func main() {
      print("Done")
    
    }
  }