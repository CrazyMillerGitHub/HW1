//
//  File.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 14/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import CoreData
class ListProvider: NSObject, UITableViewDataSource {
    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let frc =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: StorageManager.Instance.coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else { fatalError() }
        let user = self.fetchedResultsController.object(at: indexPath)
        if let image = user.image {
            cell.profileImage.image = UIImage(data: image)
            cell.profileImage.layer.cornerRadius = 22.5
        }
        let message = user.lastMessage ?? ""
        let online = user.isOnline
        guard let userID = user.userID else { fatalError("No found UserID. Are you Okay?") }
        let date = Conversation.requestLastMessageWithCurrectId(in: StorageManager.Instance.coreDataStack.mainContext, conversationID: userID)?.date
        let name = user.name ?? ""
        cell.configureCell(name: name, message: message, date: date, online: online, hasUnreadmessage: true)
        // swiftlint:enable force_cast
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = fetchedResultsController.fetchedObjects?.count
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        print(sectionInfo.numberOfObjects)
        return sectionInfo.numberOfObjects
    }
}
