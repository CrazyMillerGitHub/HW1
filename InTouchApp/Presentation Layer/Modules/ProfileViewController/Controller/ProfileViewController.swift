//
//  ProfileViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, SaveDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    func save(imageString: String) {
        imageView.imageFromServerURL(urlString: imageString, defaultImage: nil)
        self.dismiss(animated: true, completion: {
            self.statusButtons(bool: true)
            self.count = 1
            self.hideUnhideFunction()
        })
        
    }
        
    var imageBool: Bool = false
    var titleBool: Bool = false
    var descriptionTextBool: Bool = false
    @IBOutlet var gcdButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var operationButton: UIButton!
    @IBOutlet var descriptionView: UILabel!
    @IBOutlet weak var editButton: UIButton!
    var myActivityIndicator = UIActivityIndicatorView()
    var count = 0
    var increase: Bool = false
    var editLabel = UITextField()
    var editDescriptionTextView = UITextView()
    var dataProvider = ProfileViewDataProvider()
    let rootAssembly = RootAmbessy()
    
    let flakeEmitterCell = CAEmitterCell()
    
    var snowEmitterLayer: CAEmitterLayer?
    
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
    
    @IBOutlet var bgView: UIView!
    let panGestureRecognizer = UIPanGestureRecognizer()
    var panGestureAnchorPoint: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /////
        // shadow
        bgView.layer.shadowColor = UIColor.black.cgColor
        operationButton.layer.shadowColor = UIColor(red: 1.00, green: 0.18, blue: 0.33, alpha: 1.00).cgColor
        gcdButton.layer.shadowColor = UIColor(red: 0.18, green: 0.49, blue: 0.96, alpha: 1.00).cgColor
        
        editButton.layer.shadowColor = UIColor.black.cgColor
        editButton.layer.shadowOffset = CGSize(width: 0, height: 16)
        editButton.layer.shadowRadius = 26
        editButton.layer.shadowOpacity = 0.26
        
        /////
        myActivityIndicator = MyActivityIndicator(view: view)
        view.addSubview(myActivityIndicator)
        addTargets()
        loadData()
        hideUnhideFunction()
        editLabel = EditLabelClass(text: titleLabel.text ?? "", paddingView: UIView(frame: CGRect(x: 0, y: 0, width: 15, height: editLabel.frame.height)))
        editDescriptionTextView = EditDescriptionClass(descriptionText: descriptionView.text ?? "", view: view)
        view.addSubview(editLabel)
        editLabel.delegate = self
        editDescriptionTextView.delegate = self
        bgView.addSubview(editDescriptionTextView)
        statusButtons(bool: false)
        panGestureRecognizer.addTarget(self, action: #selector(showMoreActions(touch: )))
        view.addGestureRecognizer(panGestureRecognizer)
        editLabel.isHidden = true
        editDescriptionTextView.isHidden = true
    }
    @objc func showMoreActions(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        switch touch.state {
        case .possible:
             print("ke")
        case .began:
           
            snowEmitterLayer = CAEmitterLayer()
            flakeEmitterCell.contents = #imageLiteral(resourceName: "tinkoff_logo.png").cgImage
            flakeEmitterCell.scale = 0.06
            flakeEmitterCell.scaleRange = 0.3
            flakeEmitterCell.emissionRange = .pi
            flakeEmitterCell.lifetime = 7.0
            flakeEmitterCell.birthRate = 10
            flakeEmitterCell.velocity = -30
            flakeEmitterCell.velocityRange = -20
            flakeEmitterCell.yAcceleration = 30
            flakeEmitterCell.xAcceleration = 5
            flakeEmitterCell.spin = -0.5
            flakeEmitterCell.spinRange = 1.0
            
            snowEmitterLayer?.emitterPosition = CGPoint(x: touchPoint.x, y: touchPoint.y)
            snowEmitterLayer?.emitterSize = CGSize(width: 10, height: 10)
            snowEmitterLayer?.emitterShape = CAEmitterLayerEmitterShape.line
            snowEmitterLayer?.beginTime = CACurrentMediaTime()
            snowEmitterLayer?.timeOffset = 2
            snowEmitterLayer?.emitterCells = [flakeEmitterCell]
            //swiftlint:disable force_unwrapping
            view.layer.addSublayer(snowEmitterLayer!)
        case .changed:
            DispatchQueue.main.async {
               self.snowEmitterLayer?.emitterPosition = CGPoint(x: touchPoint.x, y: touchPoint.y)
            }
        case .ended:
            DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.snowEmitterLayer!.birthRate = 0
            }

        case .cancelled:
             print("ke")
        case .failed:
            print("ke")
        }

    }
    //swiftlint:enable force_unwrapping
    
    func loadData() {
        if let label = dataProvider.labelText { self.titleLabel.text = label }
        if let description = dataProvider.descriptionText { self.descriptionView.text = description }
        if let image = dataProvider.image { self.imageView.image = UIImage(data: image) }
    }

    private func addTargets() {
        addImageButton.addTarget(self, action: #selector(addImageButtonAction), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        gcdButton.addTarget(self, action: #selector(gcdButtonAction), for: .touchUpInside)
        operationButton.addTarget(self, action: #selector(operationButtonAction), for: .touchUpInside)
        editLabel.addTarget(self, action: #selector(editLabelChanged), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        editLabel.frame = self.titleLabel.frame
        //        swiftlint:disable line_length
        editDescriptionTextView.frame = CGRect(x: self.descriptionView.frame.minX, y: self.descriptionView.frame.minY, width: self.descriptionView.frame.width, height: self.descriptionView.frame.height + 10)
        //        swiftlint:enable line_length
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
        let action4 = UIAlertAction(title: "Отмена", style: .cancel) { (_:UIAlertAction) in
            myPickerController.sourceType = .photoLibrary
        }
        let action3 = UIAlertAction(title: "Загрузить", style: .default) { (_:UIAlertAction) in
            let serverView = self.rootAssembly.presentationAssembly.serverImageViewController()
            serverView.delegate = self
        self.present(serverView, animated: true, completion: nil)
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
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
        self.operationButton.isHidden = self.operationButton.isHidden ? false : true
        self.gcdButton.isHidden = self.gcdButton.isHidden ? false : true
        self.addImageButton.isHidden = self.addImageButton.isHidden ? false : true
        self.editLabel.isHidden = self.editLabel.isHidden ? false : true
        self.editDescriptionTextView.isHidden = self.editDescriptionTextView.isHidden ? false : true
    }

    @objc func editButtonAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.editButton.transform = CGAffineTransform(scaleX: 1.10, y: 1.10)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                 self.editButton.transform = CGAffineTransform.identity
                self.editButton.alpha = self.editButton.alpha == 0 ? 1 : 0
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.hideUnhideFunction()
                }
            })
        })
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
        dataManger.save()
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

// MARK: - UITextViewDelegate, UITextFieldDelegate
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

// MARK: - Сохранение данных
extension ProfileViewController: ProfileViewControllerDelegate {
    func changeProileData(success: Bool) {
        DispatchQueue.main.async {
            self.editButtonAction()
            self.myActivityIndicator.stopAnimating()
            self.statusButtons(bool: false)
            let coreData = StorageManager.Instance.coreDataStack
            let model = coreData.managedObjectModel
            let user = AppUser.fetchRequestAppUser(model: model)
            guard let userr = user else { fatalError() }
            guard let result = try? coreData.mainContext.fetch(userr) else {fatalError("Fetch failed")}
            if self.titleBool {
                if let label = result.last?.currentUser?.name {
                    self.titleLabel.text = label
                }
            }
            if self.descriptionTextBool {
                if let description = result.last?.currentUser?.descriptionText { self.descriptionView.text = description }
            }
            if self.imageBool {
                if let image = result.last?.currentUser?.image { self.imageView.image = UIImage(data: image)}
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

}

// MARK: - AlertView
extension ProfileViewController {
    
    /// AlertAction
    ///
    /// - Parameters:
    ///   - title: title description
    ///   - message: message description
    ///   - handler: handler description
    private func alert(title: String = "Данные сохраненны", _ message: String?, handler: String) {
        let alert = AlertController.shared.alert(title: title, message: message, handler: handler)
        self.present(alert, animated: true, completion: nil)
    }
}

/// AlertController
class AlertController {
    static var shared = AlertController()
    func alert(title: String, message: String?, handler: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        }))
        if handler == "err" {
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Повторить", comment: "Default action"), style: .default, handler: { _ in
            }))
        }
        return alertController
    }
}
