//
//  ProfileViewDataProvider.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 14/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation

class ProfileViewDataProvider: NSObject {
    let coreData = StorageManager.Instance.coreDataStack
    let labelText: String?
    let image: Data?
    let descriptionText: String?
    override init() {
        let model = coreData.managedObjectModel
        let user = AppUser.fetchRequestAppUser(model: model)
        guard let userr = user else { fatalError() }
        guard let result = try? coreData.mainContext.fetch(userr) else { fatalError() }
        self.labelText = result.last?.currentUser?.name ?? nil
        self.descriptionText = result.last?.currentUser?.descriptionText ?? nil
        self.image = result.last?.currentUser?.image ?? nil
        super.init()
    }
}
