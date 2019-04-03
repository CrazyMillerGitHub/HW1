//
//  ConversationsListViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 21/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData
class ConversationsListViewController: UIViewController, dataDelegate {
    func reloadData(status: Bool) {
        if status == true {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    /// NSFetchResultController
    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        let request: NSFetchRequest<User> = User.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let frc =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: StorageManager.Instance.coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        let users = frc.fetchedObjects
        return frc
    }()

    @IBOutlet private var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        CommunicatorManager.Instance.delegate = self
        CommunicatorManager.Instance.communicator.advertiser.startAdvertisingPeer()
        CommunicatorManager.Instance.communicator.browser.startBrowsingForPeers()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {}
//        do {
//        let keke = try AppUser.fetchAllUsers(in: StorageManager.Instance.coreDataStack.saveContext)
//            keke.forEach {print( $0.name) }
//        } catch {
//            print("Hello")
//        }

    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Закоментить extension, если ThemesViewController - swift file
extension ConversationsListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemesViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard  let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Когда выбрана cell, subview меняет цвет на selectionColor. Можно пофиксить с помощью extension, но пока не большая проблема
        // swiftlint:disable force_cast
//        CommunicatorManager.Instance.users.sort { (name1, name2) -> Bool in
//            var time1 = Date()
//            var time2 = Date()
//            if let time = CommunicatorManager.Instance.communicator.message[name1.peerID]?.last?.date {
//                time1 = time
//            }
//            if let time = CommunicatorManager.Instance.communicator.message[name2.peerID]?.last?.date {
//                time2 = time
//            }
//            return time1 > time2
//        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
//        //    let arr = Users.sharedInstance.configureUsers()[indexPath.section][indexPath.row]
//        var messageTime = Date()
//        var message = ""
//        if let lastMessage = CommunicatorManager.Instance.communicator.message[CommunicatorManager.Instance.users[indexPath.row].peerID] {
//            guard let last = lastMessage.last else { fatalError("You don't have message") }
//            message = last.message
//            messageTime = last.date
//        }
//        cell.configureCell(name: CommunicatorManager.Instance.users[indexPath.row].username, message: message, date: messageTime, online: true, hasUnreadmessage: true)
        let user = self.fetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = user.name
        if let image = user.image {
        cell.profileImage.image = UIImage(data: image)
            cell.profileImage.layer.cornerRadius = 22.5
        }
        // swiftlint:enable force_cast
        return cell
    }

    private func convertToDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let date = dateFormatter.date(from: string) else {
            return Date()
        }
        return date
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                        let managedObject = fetchedResultsController.object(at: indexPath)
            StorageManager.Instance.coreDataStack.mainContext.delete(managedObject)
            do { try StorageManager.Instance.coreDataStack.performSave(with: StorageManager.Instance.coreDataStack.mainContext)
//                let users = fetchedResultsController.fetchedObjects
//                print(users)
              let request2: NSFetchRequest<User> = User.fetchRequest()
                do {
                             let result2 = try StorageManager.Instance.coreDataStack.mainContext.fetch(request2)
                        print(result2.count)
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                fatalError("Save failed!!")
            }
        }
    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueIndentifier" {
//            guard let destinationViewController = segue.destination as? ConversationViewController else { return }
//            //      guard let _ = tableView.indexPathForSelectedRow?.section,
//            guard let row = tableView.indexPathForSelectedRow?.row else { return }
//            destinationViewController.userData.peerID = CommunicatorManager.Instance.users[row].peerID
//            destinationViewController.userData.userName = CommunicatorManager.Instance.users[row].username
//            print(destinationViewController.userData)
//            destinationViewController.navigationItem.title = CommunicatorManager.Instance.users[row].username
        } else if segue.identifier == "themeSegueIdentifier"{
            // swiftlint:disable force_cast
            let navigationViewController = segue.destination as! UINavigationController
            let segueViewController = navigationViewController.topViewController as! ThemesViewController
            // swiftlint:enable force_cast
            segueViewController.model = Themes()
            segueViewController.delegate = self
        }
    }

    func logThemeChanging(selectedTheme: UIColor) {
        switch selectedTheme {
        case .white:
            if let selectedTheme = Theme(rawValue: 0) {
                selectedTheme.apply()
            }
        case .black:
            if let selectedTheme = Theme(rawValue: 1) {
                selectedTheme.apply()
            }
        default:
            if let selectedTheme = Theme(rawValue: 2) {
                selectedTheme.apply()
            }
        }
    }
}

protocol ConversationCellonfiguration: class {
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessage: Bool {get set}
}
