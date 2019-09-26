//
//  CanvasText.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/25/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation

struct CanvasText {
    var width: Int
    var height: Int
    var text: String
    var fontSize: Int
    var fontColor: String
    var fontWeight: String
    var textTransform: String
    var pin: Bool
    var order: Int
}

extension CanvasText: Decodable{
    enum CanvasTextCodingKeys: String, CodingKey{
        case width
        case height
        case text
        case fontSize
        case fontColor
        case fontWeight
        case textTransform
        case pin
        case order
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CanvasTextCodingKeys.self)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        text = try container.decode(String.self, forKey: .text)
        fontSize = try container.decode(Int.self, forKey: .fontSize)
        fontColor = try container.decode(String.self, forKey: .fontColor)
        fontWeight = try container.decode(String.self, forKey: .fontWeight)
        textTransform = try container.decode(String.self, forKey: .textTransform)
        pin = try container.decode(Bool.self, forKey: .pin)
        order = try container.decode(Int.self, forKey: .pin)
    }
}
