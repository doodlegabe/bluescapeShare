//
//  Canvas.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/23/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation

struct Canvas {
    var id: String
    var workspaceId: String
    var order: Int
    var borderColor: String
    var name: String
    var x: Int
    var y: Int
    var height: Int
    var width: Int
    var children: [String]
}


extension Canvas: Decodable{
    enum CanvasCodingKeys: String, CodingKey{
        case id
        case workspaceId = "workspace_id"
        case order
        case borderColor
        case name
        case x
        case y
        case height
        case width
        case children
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CanvasCodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        workspaceId = try container.decode(String.self, forKey: .workspaceId)
        order = try container.decode(Int.self, forKey: .order)
        borderColor = try container.decode(String.self, forKey: .borderColor)
        name = try container.decode(String.self, forKey: .name)
        x = try container.decode(Int.self, forKey: .x)
        y = try container.decode(Int.self, forKey: .y)
        height = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        children = try container.decode(Array.self, forKey: .children)
    }
}


struct Canvases{
    var canvas: [Canvas]
}

extension Canvases: Decodable{
    enum CanvasesCodingKeys: String, CodingKey{
        case canvas
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CanvasesCodingKeys.self)
        canvas = try container.decode([Canvas].self, forKey: .canvas)

    }
    
}
