//
//  ServicesAssembly.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
protocol IServicesAssembly {
    var imageService: IImageService { get }
}
class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
     lazy var imageService: IImageService = PhotoService(requestSender: self.coreAssembly.requestSender)
    
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
}
