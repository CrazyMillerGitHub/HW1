//
//  ServerImageViewController.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ServerImageViewController: UIViewController {
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
    }
 
    @IBAction func act(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
