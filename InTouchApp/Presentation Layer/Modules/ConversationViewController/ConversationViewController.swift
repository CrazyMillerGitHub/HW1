//
//  ConversationViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CoreData
protocol MessageCellConfiguration: class {
    var txt: String? {get set}
}

class ConversationViewController: UIViewController, UITextFieldDelegate {
    
    func sendButtonStyle(user: Bool) {
        if user {
            UIView.animate(withDuration: 0.5, animations: {
                self.sendButton.backgroundColor = .green
                self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
                    self.sendButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.sendButton.backgroundColor = .white
                self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
                    self.sendButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            })
        }
    }
    var currectUser: User!
    var userId: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var dtProvider: ViewDataProvider!
    @IBOutlet var textField: UITextField!
    @IBOutlet var searchView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    var manager: MultipeerCommunicator!
    weak var communicator: Communicator?
    var userController: UserFetchResultController = UserFetchResultController()
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 24))
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.titleView = titleLabel
        extendedLayoutIncludesOpaqueBars = true
        guard let userID = userId else { fatalError() }
        insertMessageForCurrectUser(userID: userID, message: "Just Pray for me!")
        textField.delegate = self
        dtProvider.userId = userId
        dtProvider.currectUser = currectUser
        tableView.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        dtProvider.fetchedResultsController.delegate = self
        do {
            try dtProvider.fetchedResultsController.performFetch()
        } catch {}
        manager = MultipeerCommunicator()
        textField.addTarget(self, action: #selector(didChanged), for: .editingChanged)
        userController.completionHandler = { isOnline in
            
            if isOnline {
                self.onlineUser()
            } else {
                self.offlineUser()
            }
            return "Sucess"
        }
        
        userController.userID = userId
        userController.fetchedResultsController.delegate = userController
        do {
            try userController.fetchedResultsController.performFetch()
        } catch {
            
        }
    }
    @objc func didChanged() {
        if textField.text?.count == 1 {
            sendButtonStyle(user: true)
        } else if textField.text?.count == 0 {
            sendButtonStyle(user: false)
        }
    }
    func onlineUser() {
        UIView.animate(withDuration: 1.0) {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
            self.titleLabel.textColor = .green
            self.sendButtonStyle(user: true)
        }
    }
    
    func offlineUser() {
        UIView.animate(withDuration: 1.0) {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.titleLabel.textColor = .black
            self.sendButtonStyle(user: false)
        }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////
    private func insertMessage(_ messageString: String) -> Message? {
        let message = Message.insertMessage(in: StorageManager.Instance.coreDataStack.saveContext)
        message?.message = messageString
        return message
    }
    private func insertMessageForCurrectUser(userID: String, message: String) {
        if let currectUser = User.fetchCurrectUser(userID: userID, in: StorageManager.Instance.coreDataStack.saveContext) {
            if let message = insertMessage(message) {
                currectUser.addToMessages(message)
                StorageManager.Instance.coreDataStack.performSave()
            }
        }
    }

    @IBAction func sendAction(_ sender: Any) {
        communicator?.sendMessage(string: "d", to: "", completionHandler: nil)
        //    delegate?.sendMessage(string: textField.text!, to: "peer", completionHandler: nil)
        let array = ["eventType": "TextMessage", "text": "\(textField.text ?? "")", "messageId": "\(generateMessageId())"]
        
        StorageManager.Instance.coreDataStack.saveContext.performAndWait {
            let message = Message.insertMessage(in: StorageManager.Instance.coreDataStack.saveContext)
            message?.inOut = 0
            message?.date = Date()
            message?.message = textField.text ?? ""
            message?.messageID = generateMessageId()
            message?.conversationID = userId
            let conversation = Conversation.requestConversation(in: StorageManager.Instance.coreDataStack.saveContext, conversationID: userId)
            if let message = message { conversation?.addToMessages(message)
            }
            StorageManager.Instance.coreDataStack.performSave()
        }
        if let arr = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) {
            if let peer = CommunicatorManager.instance.communicator.mcPeerIDFunc(name: ((AppUser.requestAppUser(in: StorageManager.Instance.coreDataStack.mainContext))?.currentUser!.userID)!) {
                try? CommunicatorManager.instance.communicator.session.send(arr, toPeers: [peer], with: .reliable)
                textField.text = ""
            } else {
                self.messageNotSent()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    private func messageNotSent() {
        let alertController = UIAlertController(title: "Извините,сообщение не было отправленно", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "ОК", style: .default) { (_:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            }
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func generateMessageId() -> String {
        // swiftlint:disable force_unwrapping
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!.base64EncodedString()
        // swiftlint:enable force_unwrapping
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            var height = keyboardFrame.cgRectValue.height
            if #available(iOS 11.0, *) {
                let bottomInset = view.safeAreaInsets.bottom
                height -= bottomInset
            }
            self.bottomConstraint.constant = isKeyboardShowing ?  -height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.endEditing(true)
    }
}

class CustomConversationCell1: UITableViewCell, MessageCellConfiguration {
    var txt: String?
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var inTextLabel: UILabel!
    
    func config(text: String) {
        self.backgroundColor = .clear
        self.txt = text
        inTextLabel.text = self.txt
        bgImage.tintColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.00)
        if let image = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate) {
            bgImage.image = image
        }
    }
}

class CustomConversationCell2: UITableViewCell, MessageCellConfiguration {
    var txt: String?
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var outTextLabel: UILabel!
    
    func config(text: String) {
        self.backgroundColor = .clear
        self.txt = text
        outTextLabel.text = self.txt
        if let image = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate) {
            bgImage.image = image
        }
    }
}
extension ConversationViewController: NSFetchedResultsControllerDelegate {
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
