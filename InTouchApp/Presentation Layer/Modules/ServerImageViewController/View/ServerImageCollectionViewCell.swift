//
//  ServerImageCollectionViewCell.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ServerImageCollectionViewCell: UICollectionViewCell {
    
//  изображение,которое мы загружаем с сервера
    @IBOutlet var serverImage: UIImageView!
    
    
    /// AwakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    serverImage.layer.cornerRadius = 10
    }

}
