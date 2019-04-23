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
class ConversationsListViewController: UIViewController {
    
    /// Present ProfileViewController
    ///
    /// - Parameter sender: sender
    
    @IBAction func profileAction(_ sender: Any) {
        let rootProfileView = sendActionWithIdentifier(withIdentifier: "rootProfileSTR")
        self.present(rootProfileView, animated: true, completion: nil)
    }
    let panGestureRecognizer = UIPanGestureRecognizer()
    let flakeEmitterCell = CAEmitterCell()
    
    var snowEmitterLayer: CAEmitterLayer?
    /// Выбор темы в настройках
    ///
    @IBOutlet var listProvider: ListProvider!
    /// - Parameter sender: sender
    @IBAction func settingAction(_ sender: Any) {
        let rootProfileView = sendActionWithIdentifier(withIdentifier: "rootThemeSTD")
        guard let segueViewController = rootProfileView.topViewController as? ThemesViewController else { fatalError() }
        segueViewController.model = Themes()
        segueViewController.delegate = self
        self.present(rootProfileView, animated: true, completion: nil)
    }
    
    @IBOutlet private var tableView: UITableView!
    //swiftlint:disable identifier_name
    func sendActionWithIdentifier(withIdentifier id: String) -> UINavigationController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let rootViewController = storyBoard.instantiateViewController(withIdentifier: id) as? UINavigationController else { fatalError()
        }
        return rootViewController
    }
    //swiftlint:enable identifier_name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = true
        self.tableView.delegate = self
        CommunicatorManager.instance.communicator.advertiser.startAdvertisingPeer()
        CommunicatorManager.instance.communicator.browser.startBrowsingForPeers()
        listProvider.fetchedResultsController.delegate = self
        do {
            try listProvider.fetchedResultsController.performFetch()
        } catch {}
        panGestureRecognizer.addTarget(self, action: #selector(showMoreActions(touch: )))
        view.addGestureRecognizer(panGestureRecognizer)
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

// MARK: - NSFetchedResultsControllerDelegate
extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        //swiftlint:disable force_unwrapping
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
        //swiftlint:enable force_unwrapping
    }
}

extension ConversationsListViewController: UIGestureRecognizerDelegate {
    @objc func showMoreActions(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        switch touch.state {
        case .possible:
            print("ke")
        case .began:
            
            snowEmitterLayer = CAEmitterLayer()
            flakeEmitterCell.contents = #imageLiteral(resourceName: "tinkoff_logo.png").cgImage
            flakeEmitterCell.scale = 0.06
            flakeEmitterCell.scaleRange = 0.3
            flakeEmitterCell.emissionRange = .pi
            flakeEmitterCell.lifetime = 7.0
            flakeEmitterCell.birthRate = 10
            flakeEmitterCell.velocity = -30
            flakeEmitterCell.velocityRange = -20
            flakeEmitterCell.yAcceleration = 30
            flakeEmitterCell.xAcceleration = 5
            flakeEmitterCell.spin = -0.5
            flakeEmitterCell.spinRange = 1.0
            
            snowEmitterLayer?.emitterPosition = CGPoint(x: touchPoint.x, y: touchPoint.y)
            snowEmitterLayer?.emitterSize = CGSize(width: 10, height: 10)
            snowEmitterLayer?.emitterShape = CAEmitterLayerEmitterShape.line
            snowEmitterLayer?.beginTime = CACurrentMediaTime()
            snowEmitterLayer?.timeOffset = 2
            snowEmitterLayer?.emitterCells = [flakeEmitterCell]
            //swiftlint:disable force_unwrapping
            view.layer.addSublayer(snowEmitterLayer!)
        case .changed:
            DispatchQueue.main.async {
                self.snowEmitterLayer?.emitterPosition = CGPoint(x: touchPoint.x, y: touchPoint.y)
            }
        case .ended:
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.snowEmitterLayer!.birthRate = 0
            }
            
        case .cancelled:
            print("ke")
        case .failed:
            print("ke")
        }
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ConversationsListViewController: UITableViewDelegate {
   
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
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let messageViewController = storyBoard.instantiateViewController(withIdentifier: "messageStb") as? ConversationViewController else {
            fatalError()
        }
        guard let row = tableView.indexPathForSelectedRow?.row else { return }
        guard let userID = self.listProvider.fetchedResultsController.fetchedObjects?[row].userID else { fatalError() }
        messageViewController.currectUser = self.listProvider.fetchedResultsController.fetchedObjects?[row]
        messageViewController.userId = userID
        messageViewController.titleLabel.text = self.listProvider.fetchedResultsController.fetchedObjects?[row].name
        self.navigationController?.pushViewController(messageViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
