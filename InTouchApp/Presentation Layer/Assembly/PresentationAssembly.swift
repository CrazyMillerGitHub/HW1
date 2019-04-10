//
//  PresentationAssembly.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
class PresentationAssembly: IPresentationAssembly {
    
    func conversationViewController() -> ConversationViewController {
        return ConversationViewController()
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(coder: NSCoder())!
    }
    
    func conversationListViewController() -> ConversationsListViewController {
        return ConversationsListViewController()
    }
    
}
protocol IPresentationAssembly {
    
    /// conversationViewController
    ///
    /// - Returns: ConversationViewController класс
    func conversationViewController() -> ConversationViewController
    
    /// profileViewController
    ///
    /// - Returns: ProfileViewController класс
    func profileViewController() -> ProfileViewController
    
    /// ConversationListViewController
    ///
    /// - Returns: ConversationsListViewController класс
    func conversationListViewController() -> ConversationsListViewController
}
