//
//  MultipeerCommunicator.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 19/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData
class MultipeerCommunicator: NSObject, Communicator {
    var online: Bool

    func generateMessageId() -> String {
        // swiftlint:disable force_unwrapping
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
            .data(using: .utf8)!.base64EncodedString()
        // swiftlint:enable force_unwrapping
    }

    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {

        if self.message[peerID.displayName] == nil {
            self.message[peerID.displayName] = [MessageStruct(inOut: 0, message: string, date: Date())]
        } else {
            self.message[peerID.displayName]?.append(MessageStruct(inOut: 0, message: string, date: Date()))
        }
    }

    // MARK: - Возвращает Peer
    func mcPeerIDFunc(name: String) -> MCPeerID? {
        for value in session.connectedPeers where value.displayName == name {
            return value
        }
        return session.connectedPeers.last
    }

    var peerID: MCPeerID!
    var advertiser: MCNearbyServiceAdvertiser!
    var session: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var browser: MCNearbyServiceBrowser!
    //
    weak var delegate: CommunicatorDelegate?
    var message = [String: [MessageStruct]]()
    var converstionViewController = ConversationViewController()
    override init() {
        self.online = true
        super.init()
        let userID = AppUser.requestAppUser(in: StorageManager.Instance.coreDataStack.mainContext)?.currentUser?.userID
        peerID = MCPeerID(displayName: userID ?? UIDevice.current.name)
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate =  self
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                    discoveryInfo: ["userName": "\(UserDefaults.standard.string(forKey: "profileLabel") ?? "EmptyName")"],
                                                    serviceType: "tinkoff-chat")
        self.advertiser.delegate = self
        self.browser = MCNearbyServiceBrowser(peer: peerID,
                                              serviceType: "tinkoff-chat")
        converstionViewController.delegate = self
        browser.delegate = self
    }
}

// MARK: - MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
       
        switch state {
        case MCSessionState.connected:
            StorageManager.Instance.coreDataStack.mainContext.performAndWait {
            guard let image = AppUser.requestAppUser(in: StorageManager.Instance.coreDataStack.mainContext)?.currentUser?.image else { return }
                let base64String = image.base64EncodedString(options: .lineLength64Characters)
                let array = ["image": base64String]
                if let arr = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted) {
                    do {
                        try CommunicatorManager.instance.communicator.session.send(arr, toPeers: [peerID], with: .reliable)
                        print("Success")
                    } catch {
                        print("Message not sent")
                    }
            }
            }

        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")

        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // swiftlint:disable force_cast
        guard let convertedString = String(data: data, encoding: String.Encoding.utf8) else { fatalError() }
        if let dict = convertedString.toJSON() as? [String: AnyObject] {
            if dict["image"] != nil {
                StorageManager.Instance.coreDataStack.mainContext.performAndWait {
                    if let user = AppUser.fetchCurrectUserWithID(in: StorageManager.Instance.coreDataStack.mainContext, userId: peerID.displayName) {
                        guard let data = NSData(base64Encoded: dict["image"] as! String, options: .ignoreUnknownCharacters) else {fatalError()}
                        user.image = data as Data
                        StorageManager.Instance.coreDataStack.performSave()
                    }
                }
            } else {
                StorageManager.Instance.coreDataStack.saveContext.performAndWait {
                    
                    let message = Message.insertMessage(in: StorageManager.Instance.coreDataStack.saveContext)
                    message?.inOut = 1
                    message?.date = Date()
                    if let textMessage = dict["text"] as? String {
                        message?.message = textMessage
                    }
                    message?.messageID = generateMessageId()
                    message?.conversationID = peerID.displayName
                    let conversation = Conversation.requestConversation(in: StorageManager.Instance.coreDataStack.saveContext, conversationID: peerID.displayName)
                    if let message = message {
                        conversation?.addToMessages(message)
                        
                    }
                    StorageManager.Instance.coreDataStack.saveContext.performAndWait {
                        if let user = AppUser.fetchCurrectUserWithID(in: StorageManager.Instance.coreDataStack.saveContext, userId: peerID.displayName) {
                            if let textMessage = dict["text"] as? String {
                                user.lastMessage = textMessage
                            }
                        }
                        StorageManager.Instance.coreDataStack.performSave()
                    }
                }
                
            }
             delegate?.didRecieveMessage(text: dict["text"] as! String, fromUser: peerID.displayName, toUser: session.myPeerID.displayName)
        }
        // swiftlint:enable force_cast
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if session.connectedPeers.contains(peerID) {
            invitationHandler(false, nil)
        } else {
            invitationHandler(true, session)
        }
    }

    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {

    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {

    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        if let info = info {
            if let result = AppUser.fetchAllUsers(in: StorageManager.Instance.coreDataStack.mainContext) {
                if result.contains(where: { (user) -> Bool in
                    return user.userID == peerID.displayName ? true : false }) == false {
                    saveUser(peerID: peerID, info: info)
                } else {
                    if let user = AppUser.fetchCurrectUserWithID(in: StorageManager.Instance.coreDataStack.mainContext, userId: peerID.displayName) {
                        user.isOnline = true
                        StorageManager.Instance.coreDataStack.performSave()
                    }
            }
            }
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 5)
            delegate?.didFoundUser(userID: peerID.displayName, userName: info["userName"])
        }
    }
    func saveUser(peerID: MCPeerID, info: [String: String]) {
        StorageManager.Instance.coreDataStack.saveContext.perform {
            let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
            guard let result = try? StorageManager.Instance.coreDataStack.saveContext.fetch(request) else {fatalError("Fetch failded")}
            let user = User.insertUser(in: StorageManager.Instance.coreDataStack.saveContext)
            let requestConversations: NSFetchRequest<Conversation> = Conversation.fetchRequest()
            guard let conversations = try? StorageManager.Instance.coreDataStack.saveContext.fetch(requestConversations) else {return}
            if conversations.contains(where: { (conv) -> Bool in
                return conv.conversationID != peerID.displayName ? false : true
            }) == false {
                 let conversation = Conversation.insertConversation(in: StorageManager.Instance.coreDataStack.saveContext)
                 conversation?.conversationID = peerID.displayName
            }
            user?.name = info["userName"]
            user?.userID = peerID.displayName
            user?.isOnline = true
            if let user = user {
                StorageManager.Instance.coreDataStack.saveContext.performAndWait {
                
                result.last?.addToUsers(user)
                
                StorageManager.Instance.coreDataStack.performSave()
                }
            }
        }
        
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
    }
}

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)

    //Error
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    func didRecieveMessage(text: String, fromUser: String, toUser: String)

}

// MARK: - StringExtension
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
