//
//  UserFetchResultController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 20/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class UserFetchResultController: NSFetchedResultsController<NSFetchRequestResult>, NSFetchedResultsControllerDelegate {
    
    var userID: String = ""
    var completionHandler: ((Bool) -> String)?
    
    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        guard let request: NSFetchRequest<User> = User.fetchRequestUserWithCurrectID(userID: userID) else { fatalError("User not found. Sorry") }
        request.sortDescriptors = []
        let frc =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: StorageManager.Instance.coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .update {
            let user = fetchedResultsController.fetchedObjects
            if let state = user?.last?.isOnline { print(completionHandler?(state) ?? "") }
        }
    }
}
