//
//  ServerImageProvider.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ServerImageProvider: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var view: UIView? // передаем view экрана
    var loadMoreStatus = false
    var data: [CellDisplayModel] = []
    var completionHandler: ((Int) -> String)?
    var saveToProfileHandler: ((String) -> String)?
    let serverViewController = RootAmbessy()
    var count = 1
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch data.count {
        case 1...:
            return data.count
        default:
            return 20
        }
    }
    
    /// Загружаем ячейку
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServerCell", for: indexPath) as? ServerImageCollectionViewCell else { fatalError() }
        if data.count > 0 {
            guard URL(string: data[indexPath.row].imageUrl) != nil else { fatalError("Failed to get URl.  ") }
            cell.serverImage.imageFromServerURL(urlString: data[indexPath.row].imageUrl, defaultImage: nil)
        }
        return cell
    }
    
    /// Задаем размер ячейки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let view = view else { fatalError("No view found") }
        let withHeight = (view.layer.frame.width - 40) / 3
        return CGSize(width: withHeight, height: withHeight)
    }
    
    /// Возвращаемся обратно в профиль
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(saveToProfileHandler?(data[indexPath.row].imageUrl) ?? "")
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {

        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currectOfset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let dOffset = maximumOffset - currectOfset
        if dOffset <= 40 {
            if !loadMoreStatus {
                loadMoreStatus = true
                self.count += 1
                print(completionHandler?(self.count) ?? "")
            }
        }
    }
}
