//
//  ImageDownloadingService.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 17/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
protocol IImageService {
    func loadNewImages(pageNumber: Int, completionHandler: @escaping ([PhotoApiModel]?, String?) -> Void)
}
class PhotoService: IImageService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadNewImages(pageNumber: Int,completionHandler: @escaping ([PhotoApiModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.photoImages(pageNumber: pageNumber)
        loadImages(requestConfig: requestConfig, completionHandler: completionHandler)
    }
  
    private func loadImages(requestConfig: RequestConfig<PhotoParser>,
                          completionHandler: @escaping ([PhotoApiModel]?, String?) -> Void) {
        requestSender.send(requestConfig: requestConfig) { (result: Result<[PhotoApiModel]>) in
            switch result {
            case .success(let photos):
                completionHandler(photos, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
}
