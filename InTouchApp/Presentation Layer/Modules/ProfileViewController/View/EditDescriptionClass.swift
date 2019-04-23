//
//  EditDescriptionClass.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 14/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation

class EditDescriptionClass: UITextView {
    let descriptionText: String
    let view: UIView
    init(descriptionText: String, view: UIView) {
        self.descriptionText = descriptionText
        self.view = view
        super.init(frame: CGRect.zero, textContainer: nil)
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        viewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        self.inputAccessoryView = viewForDoneButtonOnKeyboard
        self.text = descriptionText
        self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.textColor = .gray
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func doneBtnFromKeyboardClicked() {
        self.view.endEditing(true)
    }
}
