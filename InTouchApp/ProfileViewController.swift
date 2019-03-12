//
//  ProfileViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,ProfileViewControllerDelegate {
  func changeProileData(image: Bool, title: Bool, descriptionText: Bool) {
    DispatchQueue.main.async {
    self.hideUnhideFunction()
    self.myActivityIndicator.stopAnimating()
    self.loadData()
    }
  }
  
  @IBOutlet var gcdButton: UIButton!
  @IBOutlet var titleLabel: UILabel!
  var count = 0
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet var operationButton: UIButton!
  @IBOutlet var descriptionView: UILabel!
  @IBOutlet weak var editButton: UIButton!
  let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
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
  var editLabel =  UITextField()
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
    hideUnhideFunction()
    editLabel.delegate = self
    editDescriptionTextView.delegate = self
    loadData()
  }
  func loadData(){
    if let label = UserDefaults.standard.string(forKey: "profileLabel") {
      self.titleLabel.text = label
    }
    if let description = UserDefaults.standard.string(forKey: "descriptionLabel") {
      self.descriptionView.text = description
    }
  }
  private func setTraget(){
    addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
    editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
    gcdButton.addTarget(self, action: #selector(gcdButtonAction), for: .touchUpInside)
    operationButton.addTarget(self, action: #selector(operationButtonAction), for: .touchUpInside)
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
    editLabel = UITextField(frame: self.titleLabel.frame)
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
    editDescriptionTextView.frame = descriptionView.frame
    editDescriptionTextView.text = descriptionView.text
    editDescriptionTextView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    editDescriptionTextView.textColor = .gray
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    customizeDescription()
    customizeTextField()
    editLabel.isHidden = true
    editDescriptionTextView.isHidden = true
    view.addSubview(editDescriptionTextView)
    view.addSubview(editLabel)
    // Выводились значения в viewDiDLoad для iPhone SE. То есть тот frame, который в
    // Main.StoryBoard(по x - const, по y - нет). Получается, что в viewDidLoad Constraints ещё не применимы.
    print(editButton.frame)
    Logger.SharedInstance.log(message: "Application moved from DidLayoutSubviews to Appeared: \(#function)")
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
    picker.dismiss(animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("hello")
    textField.resignFirstResponder()
    //or
    //self.view.endEditing(true)
    return true
  }
  func hideUnhideFunction(){
    if count == 0 {
      self.editLabel.isHidden = true
      self.editDescriptionTextView.isHidden = true
      self.editButton.isHidden = false
      self.operationButton.isHidden = true
      self.gcdButton.isHidden = true
      self.addImageButton.isHidden = true
      count += 1
    }else{
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
  @objc private func gcdButtonAction(){
    print(editDescriptionTextView.text)
    self.myActivityIndicator.startAnimating()
    let image = imageView.image!.pngData() as NSData?
    let vc = GCDDataManager(titleLabel: self.titleLabel.text!, description: self.descriptionView.text!, editedDescription: self.editDescriptionTextView.text!, imageView: image!, editTitle: self.editLabel.text!)
    vc.delegate = self
    vc.save()
    //    UserDefaults.standard.set("2", forKey: "Key")
  }
  @objc private func operationButtonAction(){
    //     print(UserDefaults.standard.string(forKey: "Key"))
  }

}



