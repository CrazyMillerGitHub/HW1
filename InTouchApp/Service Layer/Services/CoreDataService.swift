//
//  CoreData.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
protocol ICoreDataService {
}
class CoreDataService {
    let coreData: ICoreDara
    init(coreData: ICoreDara) {
        self.coreData = coreData
    }
}
