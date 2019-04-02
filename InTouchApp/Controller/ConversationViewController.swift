//
//  ConversationViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration: class {
    var txt: String? {get set}
}
class ConversationViewController: UIViewController, UITextFieldDelegate, dataDelegate {
    var userData = (peerID: String(), userName: String())
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var searchView: UIView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    weak var delegate: Communicator?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        extendedLayoutIncludesOpaqueBars = true
        CommunicatorManager.Instance.delegate = self
        tableView.delegate = self
        textField.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func reloadData(status: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func sendAction(_ sender: Any) {
        //    delegate?.sendMessage(string: textField.text!, to: "peer", completionHandler: nil)
        let array = ["eventType": "TextMessage", "text": "\(textField.text ?? "")", "messageId": "\(generateMessageId())"]
        if CommunicatorManager.Instance.communicator.message[userData.peerID] == nil {
            CommunicatorManager.Instance.communicator.message[userData.peerID] = [MessageStruct(inOut: 0, message: textField.text ?? "", date: Date())]
        } else {
            CommunicatorManager.Instance.communicator.message[userData.peerID]?.append(MessageStruct(inOut: 0, message: textField.text ?? "", date: Date()))
        }
        if let arr = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) {
            if let peer = CommunicatorManager.Instance.communicator.mcPeerIDFunc(name: userData.peerID) {
                try? CommunicatorManager.Instance.communicator.session.send(arr, toPeers: [peer], with: .reliable)
                textField.text = ""
                tableView.reloadData()
            } else {
                self.messageNotSent()
            }
        }
    }

    private func messageNotSent() {
        if CommunicatorManager.Instance.communicator.message[userData.peerID]?.count == 1 {
            CommunicatorManager.Instance.communicator.message[userData.peerID] = nil
        }
        let alertController = UIAlertController(title: "Извините,сообщение не было отправленно", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "ОК", style: .default) { (_:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                //        myPickerController.sourceType = .camera
                //        self.present(myPickerController, animated: true, completion: nil)
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let value = CommunicatorManager.Instance.communicator.message[userData.peerID]?.count {
            return value
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dat = CommunicatorManager.Instance.communicator.message[userData.peerID] else {fatalError("No found messages for user: \(userData.peerID)")}
        let message = dat[indexPath.row]
        if message.inOut == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? CustomConversationCell1 else {
                return tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) }
            cell.config(text: message.message)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomConversationCell2 else {
                return tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) }
            cell.config(text: message.message)
            return cell
        }
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
