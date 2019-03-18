//
//  MultipeerCommunicator.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 19/03/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class MultipeerCommunicator: NSObject {
  var peerID: MCPeerID!
  var advertiser: MCNearbyServiceAdvertiser!
  var session: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  var browser: MCNearbyServiceBrowser!
  var foundPeers = [MCPeerID]()
  var delegate: CommunicatorDelegate?
  override init() {
    super.init()
    peerID = MCPeerID(displayName: "Mike")
    session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
    session.delegate =  self
    self.advertiser = MCNearbyServiceAdvertiser(peer: peerID,
                                                discoveryInfo: ["userName": "Mike"],
                                                serviceType: "tinkoff-chat")
    self.advertiser.delegate = self
    self.browser = MCNearbyServiceBrowser(peer: peerID,
                                          serviceType: "tinkoff-chat")
    
    browser.delegate = self
  }
}
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate ,MCSessionDelegate,MCNearbyServiceAdvertiserDelegate,MCBrowserViewControllerDelegate{
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    foundPeers.append(peerID)
    
    delegate?.didFoundUser(userID: peerID.displayName, userName: peerID.displayName)
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    for (index, aPeer) in foundPeers.enumerated(){
      if aPeer == peerID {
        foundPeers.remove(at: index)
        break
      }
    }
    
    delegate?.didLostUser(userID: peerID.displayName)
  }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    
  }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    
  }
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    
  }
  
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    
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
