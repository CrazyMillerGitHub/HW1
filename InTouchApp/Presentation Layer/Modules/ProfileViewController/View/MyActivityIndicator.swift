//
//  MyActivityIndicator.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 14/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
class MyActivityIndicator: UIActivityIndicatorView {
    let view: UIView?
    init(view: UIView?) {
        self.view = view ?? nil
        super.init(frame: .zero)
        if let centerOfView = view?.center { self.center = centerOfView }
        self.hidesWhenStopped = true
        self.style = .gray
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
