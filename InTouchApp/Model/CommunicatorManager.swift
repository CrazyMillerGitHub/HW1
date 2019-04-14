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
import CoreData
struct MessageStruct {
    let inOut: Int
    let message: String
    let date: Date
}
class CommunicatorManager: NSObject, CommunicatorDelegate {
    var users: [(username: String, peerID: String)] = []
    func didFoundUser(userID: String, userName: String?) {
    }
    
    func didLostUser(userID: String) {
        print("User did lost")
        let user = AppUser.fetchCurrectUserWithID(in: StorageManager.Instance.coreDataStack.mainContext, userId: userID)
        user?.isOnline = false
        StorageManager.Instance.coreDataStack.saveContext.performAndWait {
            StorageManager.Instance.coreDataStack.performSave()
        }
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
    }
    
    var communicator: MultipeerCommunicator
    static var instance = CommunicatorManager()
    private override init() {
        self.communicator = MultipeerCommunicator()
        super.init()
        self.communicator.delegate = self
    }
    
}
