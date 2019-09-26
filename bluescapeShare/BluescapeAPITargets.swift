//
//  BluescapeAPITargets.swift
//  Bluescape Bridge
//
//  Created by Gabriel Walsh on 9/19/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import Foundation
import Moya

enum BluescapeAPITargets {
    case getCanvases(workspaceId: String)
    case addTextToCanvas(
        workspaceId: String,
        canvasId: String,
        width: Int,
        height: Int,
        text: String,
        fontColor: String,
        fontFamily: String,
        fontStyle: String,
        textTransform: String,
        backgroundColor: String,
        pin: Bool)
    case addImageToCanvas(
        workspaceId: String,
        canvasId: String,
        x: Int,
        y: Int,
        url: String,
        image: Data,
        pin: Bool,
        scale: Int)
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
        case .addTextToCanvas(let workspaceId, let canvasId, _, _, _, _, _, _, _, _, _):
            return "/workspaces/\(workspaceId)/elements/canvas/\(canvasId)/text"
        }
    }
    
    var method: Moya.Method  {
        switch self {
        case .getCanvases:
            return .get
        case .addImageToCanvas, .addTextToCanvas:
            return .post
        }
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .getCanvases, .addImageToCanvas, .addTextToCanvas:
            return .bearer
        }
    }
    
    var task: Task {
        switch self{
        case .getCanvases:
            return .requestPlain
        case .addImageToCanvas(_, _, let x, let y, let url, let image, let pin, let scale):
            var formData = [MultipartFormData]()
            let localImage = UIImage(data: image)
            let pngRepresentation = localImage!.pngData()
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
            formData.append(Moya.MultipartFormData(provider: .data(pngRepresentation!), name: "image", fileName:"sharedImage.png", mimeType: "image/png"))
            return .uploadMultipart(formData)
        case .addTextToCanvas(_, _, let width, let height, let text, let fontColor, let fontFamily, let fontStyle, let textTransform, let backgroundColor, let pin):
            var formData = [MultipartFormData]()
            let width = "\(width)".data(using: String.Encoding.utf8) ?? Data()
            let height = "\(height)".data(using: String.Encoding.utf8) ?? Data()
            let text = "\(text)".data(using: String.Encoding.utf8) ?? Data()
            let fontColor = "\(fontColor)".data(using: String.Encoding.utf8) ?? Data()
            let fontFamily = "\(fontFamily)".data(using: String.Encoding.utf8) ?? Data()
            let fontStyle = "\(fontStyle)".data(using: String.Encoding.utf8) ?? Data()
            let textTransform = "\(textTransform)".data(using: String.Encoding.utf8) ?? Data()
            let backgroundColor = "\(backgroundColor)".data(using: String.Encoding.utf8) ?? Data()
            let pin = "\(pin)".data(using: String.Encoding.utf8) ?? Data()
            formData.append(Moya.MultipartFormData(provider: .data(width), name: "width"))
            formData.append(Moya.MultipartFormData(provider: .data(height), name: "height"))
            formData.append(Moya.MultipartFormData(provider: .data(text), name: "text"))
            formData.append(Moya.MultipartFormData(provider: .data(fontColor), name: "fontColor"))
            formData.append(Moya.MultipartFormData(provider: .data(fontFamily), name: "fontFamily"))
            formData.append(Moya.MultipartFormData(provider: .data(fontStyle), name: "fontStyle"))
            formData.append(Moya.MultipartFormData(provider: .data(textTransform), name: "textTransform"))
            formData.append(Moya.MultipartFormData(provider: .data(backgroundColor), name: "backgroundColor"))
            formData.append(Moya.MultipartFormData(provider: .data(pin), name: "pin"))
            return .uploadMultipart(formData)
        }
    }
    
    var headers: [String : String]? {
        switch self{
        case .getCanvases:
            return ["Content-type": "application/json"]
        case .addImageToCanvas:
            return ["Content-type" : "multipart/form-data"]
        case .addTextToCanvas:
            return ["Content-type" : "form-data"]
        }
    }
}
