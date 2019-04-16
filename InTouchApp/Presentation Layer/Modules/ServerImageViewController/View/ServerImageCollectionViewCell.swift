//
//  ServerImageCollectionViewCell.swift
//  
//
//  Created by Михаил Борисов on 16/04/2019.
//

import UIKit

class ServerImageCollectionViewCell: UICollectionViewCell {
    
//  изображение,которое мы загружаем с сервера
    @IBOutlet var serverImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    serverImage.layer.cornerRadius = 10
    }

}
