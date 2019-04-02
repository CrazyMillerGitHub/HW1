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
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }
    weak var delegate: StorageManager?
    let dataModelName = "coreData"
    let dataModelExtension = "momd"
    lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension) else {fatalError()}
        guard let object = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("object is nill") }
        return object
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
        context.perform {
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
}


// MARK: - insertAppUser and findOrInsertAppUser
extension AppUser {
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {return nil}
        let currentUser = User.insertUser(in: context)
        appUser.currentUser = currentUser
        return appUser
    }
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        return appUser
    }    
}


// MARK: - insertUser
extension User {
    static func insertUser(in context: NSManagedObjectContext) -> User? {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User else {return nil}
        //user.appUser = user.currentAppUser
        return user
    }
}


// MARK: - fetchRequestAppUser
extension AppUser {
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            return nil
        }
        return fetchRequest
    }
}
