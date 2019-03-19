//
//  File.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 19/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
class CommunicatorManager: NSObject,CommunicatorDelegate {
  var arr = [String]()
  var peers = [String]()
  
  
  var delegate: dataDelegate?
  func didFoundUser(userID: String, userName: String?) {
    delegate?.reloadData(status: true)
  }
  func didLostUser(userID: String) {
    for (index, aPeer) in arr.enumerated(){
      if aPeer == userID {
        arr.remove(at: index)
        break
      }
    }
    delegate?.reloadData(status: true)
  }
  
  func failedToStartBrowsingForUsers(error: Error) {
    print(error.localizedDescription)
  }
  
  func failedToStartAdvertising(error: Error) {
    print(error.localizedDescription)
  }
  
  func didRecieveMessage(text: String, fromUser: String, toUser: String) {
    
  }
  var communicator:MultipeerCommunicator
  static var Instance = CommunicatorManager()
  private override init() {
    self.communicator = MultipeerCommunicator()
    super.init()
    self.communicator.delegate = self
  }
  
}
protocol dataDelegate {
  func reloadData(status: Bool)
}

