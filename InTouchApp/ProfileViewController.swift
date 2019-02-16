//
//  ProfileViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit


@IBDesignable class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  @IBOutlet weak var addImageButton: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var editButton: UIButton!
  let imagePicker = UIImagePickerController()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    editButton.layer.borderWidth = 1
    editButton.layer.borderColor = UIColor.black.cgColor
    editButton.layer.cornerRadius = 15
    addImageButton.layer.cornerRadius = 30
    imageView.layer.cornerRadius = 30
    imageView.layer.masksToBounds = true
    Logging().check("Is logging = \(StruckOfLog.isLogging)")
    addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
  }
  override func viewWillAppear(_ animated: Bool) {
    Logging().check("Application moved from DidLoad to Appearing: \(#function)")
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
   Logging().check("Application moved from DidLayoutSubviews to Appeared: \(#function)")
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    Logging().check("Application moved from Appearing to WillLayoutSubviews: \(#function)")
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    Logging().check("Application moved from WillLayoutSubviews to DidLayoutSubviews: \(#function)")
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    Logging().check("5")
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    Logging().check("6")
  }
  @objc func addImageButtonAction(){
    let myPickerController = UIImagePickerController()
    myPickerController.delegate = self
    let alertController = UIAlertController(title: "Add image", message: nil, preferredStyle: .actionSheet)
    let action1 = UIAlertAction(title: "Take a picture", style: .default) { (action:UIAlertAction) in myPickerController.sourceType = .camera
        self.present(myPickerController, animated: true, completion: nil)

       }
    
    let action2 = UIAlertAction(title: "Choose from library", style: .default) { (action:UIAlertAction) in
      myPickerController.sourceType = .photoLibrary
      self.present(myPickerController, animated: true, completion: nil)
    }
    alertController.addAction(action1)
    alertController.addAction(action2)
    self.present(alertController, animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      self.imageView.image = image
    }
    self.dismiss(animated: true, completion: nil)
  }

  
}
