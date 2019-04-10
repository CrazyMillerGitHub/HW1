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
    
}
class ServicesAssembly: IServicesAssembly {
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
}
