//
//  Photorequest.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 17/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation
class PhotoReqest: IRequest {
    fileprivate var command: String {
        assertionFailure("❌ Should use a subclass of PhotoRequest ")
        return ""
    }
    
    private var baseUrl: String = "https://pixabay.com/api/"
    private var api: String = "?key=1317965-6d1fa1bab7a3ad6d02eab5f24"
    private var page: Int
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        let urlString: String = baseUrl + api + command + "&page=\(page)"
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    init(page: Int) {
        self.page = page
    }
}

class PhotoRequestConfig: PhotoReqest {
    override var command: String { return "&q=yellow+flowers&image_type=photo&pretty=true&per_page=100" }
}
