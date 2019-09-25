//
//  CanvasImage.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/24/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import UIKit

struct CanvasImage {
    var id: String
    var x: Int
    var y: Int
    var pin: Bool
    var scale: Int
    var order: Int
    var title: String
}

extension CanvasImage: Decodable{
    enum CanvasImageCodingKeys: String, CodingKey{
        case id
        case x
        case y
        case pin
        case scale
        case order
        case title
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CanvasImageCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        x = try container.decode(Int.self, forKey: .x)
        y = try container.decode(Int.self, forKey: .y)
        pin = try container.decode(Bool.self, forKey: .pin)
        scale = try container.decode(Int.self, forKey: .scale)
        order = try container.decode(Int.self, forKey: .order)
        title = try container.decode(String.self, forKey: .title)
    }
}


/*
 
 {
     "image": {
         "id": "5d8a3a6b2762c400159223dc",
         "x": 100,
         "y": 100,
         "pin": true,
         "scale": 1,
         "order": 18,
         "title": "IMG_0327.jpeg"
     }
 }
 */
