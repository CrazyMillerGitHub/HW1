//
//  ServerimageModel.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 17/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
struct CellDisplayModel {
    let imageUrl: String
}

protocol IDemoModel: class {
    var delegate: IDemoModelDelegate? { get set }
    func fetchImages(pageNumber: Int)
}

protocol IDemoModelDelegate: class {
    func setup(dataSource: [CellDisplayModel])
    func show(error message: String)
}
class DemoModel: IDemoModel {
    
    weak var delegate: IDemoModelDelegate?
    let imageService: IImageService
    
    init(imageService: IImageService) {
        self.imageService = imageService
    }
    
    func fetchImages(pageNumber: Int) {
        imageService.loadNewImages(pageNumber: pageNumber) { (images: [PhotoApiModel]?, error) in
            if let images = images {
                let cells = images.map {CellDisplayModel(imageUrl: $0.webformatURL)}
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: error ?? "Error")
            }
        }
    }
}
