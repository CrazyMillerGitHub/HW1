//
//  Parser.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 16/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import Foundation

struct PhotoApiModel: Decodable {
    let previewURL: String
    let userImageURL: String
    let webformatURL: String
}

struct HitModel: Decodable {
    let hits: [PhotoApiModel]
    let total: Int
    let totalHits: Int
}
class PhotoParser: IParser {
    typealias Model = [PhotoApiModel]
    static var photos: [PhotoApiModel]? = []
    func parse(data: Data) -> [PhotoApiModel]? {
    
    let decoder = JSONDecoder()
    do {
             let additionalPhotos = try? decoder.decode(HitModel.self, from: data).hits
        additionalPhotos?.forEach {PhotoParser.photos?.append($0)}
    }
        return PhotoParser.photos
    }
    
}
