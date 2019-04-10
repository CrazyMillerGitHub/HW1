//
//  ICoreData.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
import CoreData
protocol ICoreDara {
    func performSave()
    func fetchRequest(in context: NSManagedObjectContext)
}
