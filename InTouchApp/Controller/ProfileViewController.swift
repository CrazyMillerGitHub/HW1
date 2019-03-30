//
//  ProfileViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageBool: Bool = false
    var titleBool: Bool = false
    var descriptionTextBool: Bool = false
    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var editLabel =  UITextField()
    @IBOutlet var operationButton: UIButton!
    @IBOutlet var descriptionView: UILabel!
    @IBOutlet weak var editButton: UIButton!
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var count = 0
    var increase: Bool = false
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //    editButton.frame = nil - нету. В ините нельзя получить значение frame. Слишком рано
        if  editButton?.frame != nil {
            print(editButton.frame)
        } else {return}
    }
    var editDescriptionTextView = UITextView()
    override func viewDidLoad() {
        super.viewDidLoad()
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
        customizeEditButton()
        customizeImageView()
        addImageButton.layer.cornerRadius = 30
        addImageButton.setImage(UIImage(named: "slr-camera-2-xxl"), for: .normal)
        setTraget()
        self.editLabel.delegate = self
        self.editDescriptionTextView.delegate = self
        loadData()
        hideUnhideFunction()
        customizeTextField()
        view.addSubview(editLabel)
        
        customizeDescription()
        view.addSubview(editDescriptionTextView)
        statusButtons(bool: false)
    }
    func loadData() {
        let coreData = StorageManager.Instance.coreDataStack
        let model = coreData.managedObjectModel
        let user = AppUser.fetchRequestAppUser(model: model)
        guard let userr = user else { fatalError() }
        guard let result = try? coreData.mainContext.fetch(userr) else {fatalError("Fetch failded")}
        if let label = result.last?.name { self.titleLabel.text = label }
        if let description = result.last?.descriptionLabel { self.descriptionView.text = description }
        if let image = result.last?.image { self.imageView.image = UIImage(data: image) }
    }
    private func setTraget() {
        addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        gcdButton.addTarget(self, action: #selector(gcdButtonAction), for: .touchUpInside)
        operationButton.addTarget(self, action: #selector(operationButtonAction), for: .touchUpInside)
        editLabel.addTarget(self, action: #selector(editLabelChanged), for: .editingChanged)
    }
    private func customizeImageView() {
        imageView.image = UIImage(named: "placeholder-user")
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
    }
    private func customizeEditButton() {
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 15
    }
    override func viewWillAppear(_ animated: Bool) {
        Logger.SharedInstance.log(message: "Application moved from DidLoad to Appearing: \(#function)")
    }
    
    func customizeTextField() {
        editLabel.text = titleLabel.text
        editLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        editLabel.textColor = .black
        editLabel.backgroundColor = .white
        editLabel.layer.borderWidth = 1.0
        editLabel.layer.borderColor = UIColor.lightGray.cgColor
        editLabel.layer.cornerRadius = 3
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: editLabel.frame.height))
        editLabel.leftView = paddingView
        editLabel.leftViewMode = UITextField.ViewMode.always
    }
    private func customizeDescription() {
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        viewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        editDescriptionTextView.inputAccessoryView = viewForDoneButtonOnKeyboard
        editDescriptionTextView.text = descriptionView.text
        editDescriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        editDescriptionTextView.textColor = .gray
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        editLabel.isHidden = true
        editDescriptionTextView.isHidden = true
        editLabel.frame = self.titleLabel.frame
        editDescriptionTextView.frame = self.descriptionView.frame
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        Logger.SharedInstance.log(message: "Application moved from Appearing to WillLayoutSubviews: \(#function)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Logger.SharedInstance.log(message: "Application moved from WillLayoutSubviews to DidLayoutSubviews: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Logger.SharedInstance.log(message: "5")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        Logger.SharedInstance.log(message: "6")
    }
    @objc private func doneBtnFromKeyboardClicked() {
        self.view.endEditing(true)
    }
    @objc func addImageButtonAction() {
        print("Выберите изображения профиля")
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        let alertController = UIAlertController(title: "Добавить изображение", message: nil, preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Камера", style: .default) { (_:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                myPickerController.sourceType = .camera
                self.present(myPickerController, animated: true, completion: nil)}
            
        }
        let action2 = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { (_:UIAlertAction) in
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
        }
        let action3 = UIAlertAction(title: "Отмена", style: .cancel) { (_:UIAlertAction) in
            myPickerController.sourceType = .photoLibrary
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = pickedImage
        picker.dismiss(animated: true, completion: {
            self.statusButtons(bool: true)
            self.count = 1
            self.hideUnhideFunction()
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func hideUnhideFunction() {
        if count == 0 {
            self.editLabel.isHidden = true
            self.editDescriptionTextView.isHidden = true
            self.editButton.isHidden = false
            self.operationButton.isHidden = true
            self.gcdButton.isHidden = true
            self.addImageButton.isHidden = true
            count += 1
        } else {
            self.editLabel.isHidden = false
            self.editDescriptionTextView.isHidden = false
            self.editButton.isHidden = true
            self.operationButton.isHidden = false
            self.gcdButton.isHidden = false
            self.addImageButton.isHidden = false
            count-=1
        }
    }
    @objc func editButtonAction() {
        DispatchQueue.main.async {
            self.hideUnhideFunction()
        }
    }
    private func check() -> [String: Any] {
        var arr = [String: Any]()
        if editLabel.text != titleLabel.text {
            arr["title"] = editLabel.text
            self.titleBool = true
        } else {
            self.titleBool = false
        }
        if editDescriptionTextView.text != descriptionView.text {
            arr["description"] = editDescriptionTextView.text
            self.descriptionTextBool = true
        } else {
            self.descriptionTextBool = false
        }
        guard let image = imageView.image?.jpegData(compressionQuality: 0.5) as NSData? else {fatalError("Image is empty")}
        arr["image"] = image
        self.imageBool = true
        return arr
    }
    @objc private func gcdButtonAction() {
        statusButtons(bool: false)
        self.myActivityIndicator.startAnimating()
        let dataManger = GCDDataManager(arr: check())
        dataManger.delegate = self
        dataManger.save()
    }
    @objc private func operationButtonAction() {
        self.myActivityIndicator.startAnimating()
        statusButtons(bool: false)
        let dataManger = OperationDataManager(arr: check())
        dataManger.delegate = self
        dataManger.apply()
    }
    private func statusButtons(bool: Bool = false) {
        gcdButton.isEnabled = bool
        operationButton.isEnabled = bool
    }
    func moveText(moveDistance: Int, upAction: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(upAction ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}

extension ProfileViewController: UITextViewDelegate, UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        moveText(moveDistance: -250, upAction: true)
        increase = true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        moveText(moveDistance: -250, upAction: true)
        increase = true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        moveText(moveDistance: 250, upAction: true)
        increase = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveText(moveDistance: 250, upAction: true)
        increase = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func editLabelChanged() {
        if titleLabel.text != editLabel.text {
            statusButtons(bool: true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currect = editDescriptionTextView.text + text
        if descriptionView.text != currect {
            statusButtons(bool: true)
        }
        return true
    }
}
extension ProfileViewController: ProfileViewControllerDelegate {
    func changeProileData(success: Bool) {
        DispatchQueue.main.async {
            self.hideUnhideFunction()
            self.myActivityIndicator.stopAnimating()
            self.statusButtons(bool: false)
            let coreData = StorageManager.Instance.coreDataStack
            let model = coreData.managedObjectModel
            let user = AppUser.fetchRequestAppUser(model: model)
            guard let userr = user else { fatalError() }
            guard let result = try? coreData.mainContext.fetch(userr) else {fatalError("Fetch failed")}
            if self.titleBool {
                if let label = result.last?.name {
                    self.titleLabel.text = label
                }
            }
            if self.descriptionTextBool {
                if let description = result.last?.descriptionLabel { self.descriptionView.text = description }
            }
            if self.imageBool {
                if let image = result.last?.image { self.imageView.image = UIImage(data: image)}
            }
            if self.increase {
                self.view.endEditing(true)
            }
            if success {
                self.alert(nil, handler: "nope")
            } else {
                self.alert(title: "Ошибка", "Не удалось сохранить данные", handler: "err")
            }
        }
    }
    
    private func alert(title: String = "Данные сохраненны", _ message: String?, handler: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        if handler == "err" {
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Повторить", comment: "Default action"), style: .default, handler: { _ in
                self.gcdButtonAction()
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
