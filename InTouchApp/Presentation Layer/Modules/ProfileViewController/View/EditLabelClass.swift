//
//  EditLabelClass.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 14/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation

/// Создание класса, который изменяет вид textField, который изменяет title
class EditLabelClass: UITextField {
    let textLabel: String
    let paddingView: UIView
    init(text: String, paddingView: UIView) {
        self.textLabel = text
        self.paddingView = paddingView
        super.init(frame: .zero)
        self.text = textLabel
        self.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.textColor = .black
        self.backgroundColor = .white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 3
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
