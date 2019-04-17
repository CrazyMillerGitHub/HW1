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
}

struct HitModel: Decodable {
    //swiftlint:disable identifier_name
    let hits: [PhotoApiModel]
    let total: Int
    let totalHits: Int
}
class PhotoParser: IParser {
    typealias Model = [PhotoApiModel]
    func parse(data: Data) -> [PhotoApiModel]? {
      let decoder = JSONDecoder()
        var photos: [PhotoApiModel]? = []
        do {
            photos = try decoder.decode(HitModel.self, from: data).hits
        } catch {
            print("not today")
        }
        return photos
    }
}
