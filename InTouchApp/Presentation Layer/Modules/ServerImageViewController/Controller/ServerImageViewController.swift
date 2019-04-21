//
//  ServerImageViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
protocol SaveDelegate: class {
    func save(imageString: String)
}
class ServerImageViewController: UIViewController, IDemoModelDelegate {
    weak var delegate: SaveDelegate?
    func save(imageString: String) {
        delegate?.save(imageString: imageString)
    }
    
    private let model: IDemoModel
    
    // DisplayModel
    private var dataSource: [CellDisplayModel] = []
    
    init(model: IDemoModel ) {
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
        dataProvider.loadMoreStatus = false
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
        dataProvider.completionHandler = { count in
            self.model.fetchImages(pageNumber: count)
            return "Success"
        }
        dataProvider.saveToProfileHandler = { string in
            self.save(imageString: string)
            return "Success"
            
        }
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
}
} 
