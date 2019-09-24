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
    var x: Int
    var y: Int
    var url: URL
    var image: Data
    var pin: Bool
    var scale: Int
}

extension CanvasImage: Decodable{
    enum CanvasImageCodingKeys: String, CodingKey{
        case x
        case y
        case url
        case image
        case pin
        case scale
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CanvasImageCodingKeys.self)
        x = try container.decode(Int.self, forKey: .x)
        y = try container.decode(Int.self, forKey: .y)
        url = try container.decode(URL.self, forKey: .url)
        image = try container.decode(Data.self, forKey: .image)
        pin = try container.decode(Bool.self, forKey: .pin)
        scale = try container.decode(Int.self, forKey: .scale)
    }
}
