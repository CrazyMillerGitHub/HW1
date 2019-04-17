//
//  RootAmbessy.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 17/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
class RootAmbessy {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(serviceAssembly: self.serviceAssembly)
    private lazy var serviceAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: self.coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
