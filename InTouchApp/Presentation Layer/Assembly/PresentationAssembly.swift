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
    
    private let serviceAssembly: IServicesAssembly

    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func serverImageViewController() -> ServerImageViewController {
        let model = demoModel()
        let demoVC = ServerImageViewController(model: model)
        model.delegate = demoVC
        return demoVC
    }
    private func demoModel() -> IDemoModel {
        return DemoModel(imageService: serviceAssembly.imageService)
    }
    
    
    func conversationViewController() -> ConversationViewController {
        return ConversationViewController()
    }
    
    func profileViewController() -> ProfileViewController {
        return ProfileViewController(coder: NSCoder())!
    }
    
}
protocol IPresentationAssembly {
    
    /// conversationViewController
    ///
    /// - Returns: ConversationViewController класс
    func conversationViewController() -> ConversationViewController
    
    
    /// ServerViewController
    ///
    /// - Returns: возвращает ServerImageViewController класс
    func serverImageViewController() -> ServerImageViewController
    
    /// profileViewController
    ///
    /// - Returns: ProfileViewController класс
    func profileViewController() -> ProfileViewController
    
    /// ConversationListViewController
    ///
    /// - Returns: ConversationsListViewController класс
//    func conversationListViewController() -> ConversationsListViewController
}
