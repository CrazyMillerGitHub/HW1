//
//  CoreDataStack.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 20/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class CoreDataStack: NSObject {
  var storeURL: URL {
    let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documentsUrl.appendingPathComponent("MyStore.sqlite")
  }
  weak var delegate: StorageManager?
  let dataModelName = "coreData"
  let dataModelExtension = "momd"
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: nil)
    } catch {
      assert(false, "Error adding store: \(error)")
    }
    return coordinator
  }()

  lazy var masterContext: NSManagedObjectContext = {
    var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
    masterContext.mergePolicy = NSOverwriteMergePolicy
    return masterContext
  }()

  lazy var mainContext: NSManagedObjectContext = {
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    mainContext.parent = self.masterContext
    mainContext.mergePolicy = NSOverwriteMergePolicy
    return mainContext
  }()
  
  lazy var saveContext: NSManagedObjectContext = {
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    mainContext.parent = self.mainContext
    mainContext.mergePolicy = NSOverwriteMergePolicy
    return mainContext
  }()

  typealias SaveCompletion = () -> Void
  func performSave(with context: NSManagedObjectContext, completion: SaveCompletion? = nil) {
    guard context.hasChanges else {
      completion?()
      return
    }
    context.perform {
      do {
        try context.save()
      } catch {
        print("\(error)")
      }
      if let parentContext = context.parent {
        self.performSave(with: parentContext, completion: completion)
      } else {
        completion?()
      }
    }
  }
}

extension AppUser {
  static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
    guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {return nil}
    return appUser
  }
}

  extension AppUser {
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
      let templateName = "AppUser"
      guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
        return nil
      }
      return fetchRequest
    }
  }
