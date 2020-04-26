//
//  InfoModel.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import Foundation

struct InfoModel: Decodable {
    var data: ProductData?
}

struct ProductData: Decodable {
    var totalCount: Int?
    var product: [Product?]?
}

struct Product: Decodable {
    var id: Int?
    var name: String?
    var thumbnail: String?
    var description: Description?
    var rate: Float?
}

struct Description: Decodable {
    
    var imagePath: String?
    var subject: String?
    var price: Int?
    
}
