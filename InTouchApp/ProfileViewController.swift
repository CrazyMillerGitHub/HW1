//
//  ProfileViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var editButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customizeEditButton()
    customizeImageView()
    addImageButton.layer.cornerRadius = 30
    Logger.SharedInstance.log(message:"Is logging = \(Logger.SharedInstance)")
    print(editButton.frame)
    addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
  }
  private func customizeImageView(){
    imageView.layer.cornerRadius = 30
    imageView.layer.masksToBounds = true
  }
  private func customizeEditButton(){
    editButton.layer.borderWidth = 1
    editButton.layer.borderColor = UIColor.black.cgColor
    editButton.layer.cornerRadius = 15
  }
  override func viewWillAppear(_ animated: Bool) {
    Logger.SharedInstance.log(message:"Application moved from DidLoad to Appearing: \(#function)")
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    // Сложно описать почему разные значения, но я заметил что выводились значения в viewDiDLoad для iPhone SE. То есть тот frame, который в Main.StoryBoard(по x - const, по y - нет). Получается, что в это время Constraints ещё не применимы.
    print(editButton.frame)
   Logger.SharedInstance.log(message:"Application moved from DidLayoutSubviews to Appeared: \(#function)")
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    Logger.SharedInstance.log(message:"Application moved from Appearing to WillLayoutSubviews: \(#function)")
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    Logger.SharedInstance.log(message:"Application moved from WillLayoutSubviews to DidLayoutSubviews: \(#function)")
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    Logger.SharedInstance.log(message:"5")
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
   Logger.SharedInstance.log(message:"6")
  }
  @objc func addImageButtonAction(){
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self
    let alertController = UIAlertController(title: "Добавить изображение", message: nil, preferredStyle: .actionSheet)
    let action1 = UIAlertAction(title: "Камера", style: .default) { (action:UIAlertAction) in myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)

       }
    
    let action2 = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { (action:UIAlertAction) in
      myPickerController.sourceType = .photoLibrary
      self.present(myPickerController, animated: true, completion: nil)
    }
    alertController.addAction(action1)
    alertController.addAction(action2)
    self.present(alertController, animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let pickedImage = info[.originalImage] as? UIImage else { return }
    self.imageView.image = pickedImage
    self.dismiss(animated: true, completion: nil)
  }

  
}
