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
class CommunicatorManager: NSObject, CommunicatorDelegate {
  var users: [(username: String, peerID: String)] = []
  weak var delegate: dataDelegate?
  func didFoundUser(userID: String, userName: String?) {
    users.append((userName!, userID))
    print(users)
    delegate?.reloadData(status: true)
  }
  func didLostUser(userID: String) {
    for (index, aPeer) in users.enumerated() where aPeer.peerID == userID {
      users.remove(at: index)
      break
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
    delegate?.reloadData(status: true)
  }
  var communicator: MultipeerCommunicator
  static var Instance = CommunicatorManager()
  private override init() {
    self.communicator = MultipeerCommunicator()
    super.init()
    self.communicator.delegate = self
  }

}
protocol dataDelegate: class {
  func reloadData(status: Bool)
}
