//
//  BluescapeAPITargets.swift
//  Bluescape Bridge
//
//  Created by Gabriel Walsh on 9/19/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

struct BluescapeAPIFontFamilies {
    static let dosis = "Dosis"
    static let helvetica = "Helvetica"
    static let newTimesRoman = "Times New Roman"
    static let sourceCodePro = "Source Code Pro"
    static let aleo = "Aleo"
    static let exo = "Exo 2"
}

struct BluescapeAPIFontWeights {
    static let normal = "normal"
    static let bold = "bold"
}

struct BluescapeAPIFontStyles {
    static let normal = "normal"
    static let italic = "italic"
}

struct BluescapeAPITextTransforms {
    static let inherit = "inherit"
    static let uppercase = "uppercase"
}

struct BluescapeAPIStrokeObjectTypes {
    static let notes = "notes"
    static let images = "images"
    static let canvas = "canvas"
}

struct BluescapeAPIPenColors {
    static let white = "White"
    static let gray = "Gray"
    static let yellow = "Yellow"
    static let red = "Red"
    static let green = "Green"
    static let purple = "Purple"
    static let cyan = "Cyan"
}

struct BluescapeAPIBrushTypes{
    static let pen = "Pen"
    static let eraser = "Eraser"
}

enum BluescapeAPITargets {
    case getWorkspace(workspaceId: String)
    case getCanvases(workspaceId: String)
    case getCanvas(workspaceId: String, cavasId: String)
    case addTextToCanvas(
        workspaceId: String,
        cavasId: String,
        x: Int,
        y: Int,
        width: Int,
        height: Int,
        text: String,
        fontFamily: BluescapeAPIFontFamilies,
        fontStyle: BluescapeAPIFontStyles,
        textTransmform: BluescapeAPITextTransforms,
        backgroundColor: String,
        pin: Bool)
    case addImageToCanvas(
        workspaceId: String,
        cavasId: String,
        x: Int,
        y: Int,
        url: URL,
        image: Int,
        pin: Bool,
        scale: Int)
    case addStrokesToCanvas(
        workspaceId: String,
        objectType: BluescapeAPIStrokeObjectTypes,
        objectId: String,
        penColor: BluescapeAPIPenColors,
        brushSize: Int,
        brushType: BluescapeAPIBrushTypes,
        points: [Any]
    )
}

extension BluescapeAPITargets: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.cnn.com/")!
    }
    
    var path: String {
        switch self {
        case .getWorkspace:
            return ""
        default:
            return ""
        }
    }
    
    var method: Moya.Method  {
        switch self {
        case .getWorkspace, .getCanvases, .getCanvas:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getWorkspace(let workspaceId):
            return Data("{\"id\": \(workspaceId)}".utf8Encoded)
        default:
            return Data("Half measures are as bad as nothing at all.".utf8Encoded)
        }
    }
    
    var task: Task {
        switch self{
            case .getWorkspace:
                 return .requestPlain
            default:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
