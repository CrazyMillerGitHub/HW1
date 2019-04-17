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
        activityindicator = MyActivityIndicator(view: nil)
        view.addSubview(activityindicator)
        dataProvider.view = view
        collectionView.dataSource = dataProvider
        collectionView.delegate = dataProvider
        model.fetchImages()
 
    }
    @IBAction func act(_ sender: Any) {

    }
}

// MARK: - Сохранение результата
extension ServerImageViewController: SaveDelegate {
    func save(sender: ServerImageProvider) {
        self.dismiss(animated: true, completion: nil)
    }

}
