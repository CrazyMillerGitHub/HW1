//
//  CoreAssambley.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit

protocol ICoreAssembly {
    var coreData: ICoreDara { get }
    var operationDataManager: ISaveProfile { get }
    var gcdDataManager: ISaveProfile { get }
}
class CoreAssembly: ICoreAssembly {
    
    var operationDataManager: ISaveProfile = OperationDataManager(arr: ["String": "Any"])
    
    var gcdDataManager: ISaveProfile = GCDDataManager(arr: ["String" : "Any"])
    
    var coreData: ICoreDara = CoreDataStack()
    
}
