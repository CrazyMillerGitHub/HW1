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
    /// Получение всех users
    ///
    /// - Parameter context: context description
    /// - Returns: return value description
    static func fetchAllUsers(in context: NSManagedObjectContext) -> [User] {
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
        guard let result = try? context.fetch(request) else {fatalError("Fetch failded")}
        guard let results = result.last?.users?.allObjects as? [User] else {fatalError("No users")}
        return results
    }
    /// Получение всех пользователей онлайн
    ///
    /// - Parameter context: context
    /// - Returns: [Users]
    static func fetchAllOnlineUsers(in context: NSManagedObjectContext) -> [User] {
        let users = fetchAllUsers(in: context)
        var onlineUsers: [User] = []
        for user in users where user.isOnline == true {
            onlineUsers.append(user)
        }
        return onlineUsers
    }
    /// Получение конкретного пользователя по iD
    ///
    /// - Parameters:
    ///   - context:  context
    ///   - userId: userId
    /// - Returns: User
    static func fetchCurrectUserWithID(in context: NSManagedObjectContext, userId: String) -> User {
        let users = fetchAllUsers(in: context)
        for user in users where user.userID == userId { return user}
        fatalError()
    }
}
// MARK: - Message
extension Message {
    static func insertMessage(in context: NSManagedObjectContext) -> Message? {
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message else {return nil}
        return message
    }
}
extension Conversation {
    static func insertConversation(in context: NSManagedObjectContext) -> Conversation? {
        guard let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation else {return nil}
        return conversation
    }
}

// MARK: - Conversation
extension Conversation {
    /// Получение Сообщений по ID
    ///
    /// - Parameters:
    ///   - context: context
    ///   - conversationID: ID диалога
    static func fetchMessagesWithCurrectId(in context: NSManagedObjectContext, conversationID: String) -> [Message] {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        request.predicate = NSPredicate(format: "conversationID == %@", conversationID)
        guard let result = try? StorageManager.Instance.coreDataStack.mainContext.fetch(request) else {fatalError("Fetch failded")}
         guard let results = result.last?.messages?.allObjects as? [Message] else {fatalError("No messages")}
        return results
    }
    /// получения беседы с определенным conversationId
    ///
    /// - Parameters:
    ///   - context: context
    ///   - conversationID: ID
    /// - Returns: беседа
    static func fetchConversation(in context: NSManagedObjectContext, conversationID: String) -> Conversation {
        let request: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        guard let conversations = try? StorageManager.Instance.coreDataStack.mainContext.fetch(request) else {fatalError("Fetch failded")}
        for conversation in conversations where conversation.conversationID == conversationID {
            return conversation
        }
        fatalError("Unsuccesful fetch Conversation")
    }
}
