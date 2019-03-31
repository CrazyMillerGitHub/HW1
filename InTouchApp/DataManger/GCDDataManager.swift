//
//  GCDDataManager.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 11/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CoreData
class GCDDataManager: NSObject {
    weak var delegate: ProfileViewControllerDelegate?
    var arr = [String: Any]()
    
    init(arr: [String: Any]) {
        self.arr = arr
    }
    
    
    /// Сохранение с помощью GCD
    func save() {
        let group = DispatchGroup()
        let concurentQueue = DispatchQueue(label: "com.apple.queue", qos: .utility, attributes: .concurrent)
        group.enter()
        StorageManager.Instance.coreDataStack.mainContext.performAndWait {
            let user = AppUser.findOrInsertAppUser(in: StorageManager.Instance.coreDataStack.mainContext)
            
            concurentQueue.async {
                if let title = self.arr["title"] as? String {
                    UserDefaults.standard.set(title, forKey: "profileLabel")
                    print("hello")
                    StorageManager.Instance.coreDataStack.mainContext.performAndWait {
                        user?.name = title
                    }
                }
                group.leave()
            }
            
            group.enter()
            concurentQueue.async {
                if let image = self.arr["image"] as? NSData {
                    StorageManager.Instance.coreDataStack.mainContext.performAndWait {
                        user?.image = image as Data
                    }
                }
                group.leave()
            }
            
            group.enter()
            concurentQueue.async {
                if let description = self.arr["description"] as? String {
                    StorageManager.Instance.coreDataStack.mainContext.performAndWait {
                        user?.descriptionLabel = description
                    }
                }
                group.leave()
            }
            group.notify(queue: concurentQueue, execute: {
                StorageManager.Instance.coreDataStack.performSave(with: StorageManager.Instance.coreDataStack.mainContext)
                self.delegate?.changeProileData(success: true)
            })
        }
    }
}
