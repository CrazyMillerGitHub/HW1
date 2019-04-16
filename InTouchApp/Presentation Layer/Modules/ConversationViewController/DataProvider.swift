//
//  DataProvider.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 14/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import CoreData

class ViewDataProvider: NSObject,UITableViewDataSource {
    
    var userId: String?
    var dataManager = DataManager()
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [sort]
        guard let userID = userId else { fatalError("Not found UserID") }
        request.predicate = NSPredicate(format: "conversationID == %@", "\(userID)")
        let frc =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: StorageManager.Instance.coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0 }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.fetchedResultsController.object(at: indexPath)
        if message.inOut == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CustomConversationCell1 else {
                return tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) }
            let message = message.message ?? ""
            cell.config(text: message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomConversationCell2 else {
                return tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) }
            let message = message.message ?? ""
            cell.config(text: message)
            return cell
        }
    }
}
