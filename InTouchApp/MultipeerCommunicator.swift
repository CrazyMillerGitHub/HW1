//
//  MultipeerCommunicator.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 19/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class MultipeerCommunicator: NSObject,Communicator {
  var online: Bool
  func generateMessageId() -> String {
    return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)"
      .data(using: .utf8)!.base64EncodedString()
  }
  func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
    
    if self.message[peerID.displayName] == nil{
      self.message[peerID.displayName] = [(0,string, Date())]
    }else{
      self.message[peerID.displayName]?.append((0,string, Date()))
    }
  }
  
  //  var online: Bool
  
  var peerID: MCPeerID!
  var advertiser: MCNearbyServiceAdvertiser!
  var session: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  var browser: MCNearbyServiceBrowser!
  //
  var foundPeers = [MCPeerID: String]()
  //
  var delegate: CommunicatorDelegate?
  var message = [String: [(Int,String,Date)]]()
  var vc = ConversationViewController()
  override init() {
    self.online = true
    super.init()
    peerID = MCPeerID(displayName: UIDevice.current.name)
    session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
    session.delegate =  self
    self.advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                discoveryInfo: ["userName": "Fred"],
                                                serviceType: "tinkoff-chat")
    self.advertiser.delegate = self
    self.browser = MCNearbyServiceBrowser(peer: peerID,
                                          serviceType: "tinkoff-chat")
    vc.delegate = self
    browser.delegate = self
  }
  
}
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate ,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate,MCBrowserViewControllerDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case MCSessionState.connected:
      print("Connected: \(peerID.displayName)")
      
    case MCSessionState.connecting:
      print("Connecting: \(peerID.displayName)")
      
    case MCSessionState.notConnected:
      print("Not Connected: \(peerID.displayName)")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    let convertedString = String(data: data, encoding: String.Encoding.utf8)
    if let dict = convertedString!.toJSON() as? [String:AnyObject]{
      if self.message[peerID.displayName] == nil{
        self.message[peerID.displayName] = [(1,dict["text"] as! String, Date())]
      }else{
        self.message[peerID.displayName]?.append((1,dict["text"] as! String, Date()))
      }
      delegate?.didRecieveMessage(text: dict["text"] as! String, fromUser: peerID.displayName, toUser: session.myPeerID.displayName)
    }
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
  
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    foundPeers[peerID] = info!["userName"]
    browser.invitePeer(peerID, to: session, withContext: nil, timeout: 5)
    delegate?.didFoundUser(userID: peerID.displayName, userName: info!["userName"])
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    delegate?.didLostUser(userID: peerID.displayName)
  }
}
protocol CommunicatorDelegate: class {
  func didFoundUser(userID:String,userName: String?)
  func didLostUser(userID:String)
  
  //Error
  func failedToStartBrowsingForUsers(error: Error)
  func failedToStartAdvertising(error: Error)
  
  func didRecieveMessage(text: String,fromUser: String, toUser: String)
  
}

extension String {
  func toJSON() -> Any? {
    guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
    return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
  }
}

