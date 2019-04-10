//
//  SaveProfileService.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 10/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
import UIKit
protocol ISaveProfileService {
    
}
class SaveProfileService:ISaveProfileService  {
    let saveProfile: ISaveProfile
    init(saveProfile: ISaveProfile) {
        self.saveProfile = saveProfile
    }
}
