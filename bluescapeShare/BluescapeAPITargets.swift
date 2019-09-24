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
//    case getWorkspace(workspaceId: String)
    case getCanvases(workspaceId: String)
//    case getCanvas(workspaceId: String, cavasId: String)
//    case addTextToCanvas(
//        workspaceId: String,
//        cavasId: String,
//        x: Int,
//        y: Int,
//        width: Int,
//        height: Int,
//        text: String,
//        fontFamily: BluescapeAPIFontFamilies,
//        fontStyle: BluescapeAPIFontStyles,
//        textTransmform: BluescapeAPITextTransforms,
//        backgroundColor: String,
//        pin: Bool)
    case addImageToCanvas(
        workspaceId: String,
        canvasId: String,
        x: Int,
        y: Int,
        url: URL,
        image: Data,
        pin: Bool,
        scale: Int)
//    case addStrokesToCanvas(
//        workspaceId: String,
//        objectType: BluescapeAPIStrokeObjectTypes,
//        objectId: String,
//        penColor: BluescapeAPIPenColors,
//        brushSize: Int,
//        brushType: BluescapeAPIBrushTypes,
//        points: [Any]
//    )
}

extension BluescapeAPITargets: TargetType, AccessTokenAuthorizable  {
    
    var baseURL: URL {
        return URL(string: APIKeys.baseAPIPath)!
    }
    
    var path: String {
        switch self {
            case .getCanvases(let workspaceId):
                return "/workspaces/\(workspaceId)/elements/canvas"
        case .addImageToCanvas(let workspaceId, let canvasId, _, _, _, _ , _, _):
                return "/workspaces/\(workspaceId)/elements/canvas/\(canvasId)/images"
        }
    }
    
    var method: Moya.Method  {
        switch self {
            case .getCanvases:
                return .get
            case .addImageToCanvas:
                return .post
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
            case .getCanvases, .addImageToCanvas:
                return .bearer
            }
    }
    
    var task: Task {
        switch self{
            case .getCanvases:
                 return .requestPlain
        case .addImageToCanvas(_, _, let x, let y, let url, let image, let pin, let scale):
            var formData = [MultipartFormData]()
            let urlData = "\(url)".data(using: String.Encoding.utf8) ?? Data()
            let xData = "\(x)".data(using: String.Encoding.utf8) ?? Data()
            let yData = "\(y)".data(using: String.Encoding.utf8) ?? Data()
            let pinData = "\(pin)".data(using: String.Encoding.utf8) ?? Data()
            let scaleData = "\(scale)".data(using: String.Encoding.utf8) ?? Data()
            formData.append(Moya.MultipartFormData(provider: .data(urlData), name: "url"))
            formData.append(Moya.MultipartFormData(provider: .data(xData), name: "x"))
            formData.append(Moya.MultipartFormData(provider: .data(yData), name: "y"))
            formData.append(Moya.MultipartFormData(provider: .data(pinData), name: "pin"))
            formData.append(Moya.MultipartFormData(provider: .data(scaleData), name: "scale"))
            formData.append(Moya.MultipartFormData(provider: .data(image), name: "image", mimeType: "image/jpeg"))
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .getCanvases:
            return ["Content-type": "application/json"]
        case .addImageToCanvas:
            return ["Content-type" : "multipart/form-data"]
        }
    }
}
