//
//  ServerImageViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ServerImageViewController: UIViewController, IDemoModelDelegate {
    
    private let model: IDemoModel
    
    // DisplayModel
    private var dataSource: [CellDisplayModel] = []
    
    init(model: IDemoModel) {
        self.model = model
        
        super.init(nibName: "ServerImageViewController", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(dataSource: [CellDisplayModel]) {
        self.dataSource = dataSource
        dataProvider.data = dataSource
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.activityindicator.stopAnimating()
        }
    }
    
    func show(error message: String) {
        print("Error")
    }
    
    @IBOutlet var dataProvider: ServerImageProvider!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var activityindicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ServerImageCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ServerCell")
        view.addSubview(activityindicator)
        dataProvider.view = view
        collectionView.dataSource = dataProvider
        collectionView.delegate = dataProvider
        model.fetchImages(pageNumber: 1)
 
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
}
} 
// MARK: - Сохранение результата
extension ServerImageViewController: SaveDelegate {
    
    ///! Здесь где-то проблема с  delegate. Значение отправлению. 
    /// Добавление новых элементов
    ///
    /// - Parameter number:
    func addNewElements(number: Int) {
        model.fetchImages(pageNumber: number)
    }
    
    func save(sender: ServerImageProvider) {
        self.dismiss(animated: true, completion: nil)
    }

}
