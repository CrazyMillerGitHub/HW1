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
class ServerImageViewController: UIViewController, IDemoModelDelegate, UIGestureRecognizerDelegate {
    weak var delegate: SaveDelegate?
    func save(imageString: String) {
        delegate?.save(imageString: imageString)
    }
    let panGestureRecognizer = UIPanGestureRecognizer()
    let flakeEmitterCell = CAEmitterCell()
    
    var snowEmitterLayer: CAEmitterLayer?
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
        panGestureRecognizer.addTarget(self, action: #selector(showMoreActions(touch: )))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
}
