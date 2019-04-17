//
//  SaveDelegate.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
protocol SaveDelegate: AnyObject {
    func save(sender: ServerImageProvider)
}
