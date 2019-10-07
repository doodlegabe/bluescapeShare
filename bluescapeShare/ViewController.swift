//
//  ViewController.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/20/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
        
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var statusText: UILabel!
    
    func getCanvases(canvasesCompletionHandler: @escaping (Canvases?, Error?) -> Void){
        let bluescapeAPIProvider = NetworkManager.provider
        bluescapeAPIProvider.request(.getCanvases(workspaceId: String(APIKeys.bluescapeAPIWorkspaceID))) { result in
            switch result {
            case let .success(moyaResponse):
                do{
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let canvasesResult = try filteredResponse.map(Canvases.self)
                    if let canvases = canvasesResult as Canvases?{
                        canvasesCompletionHandler(canvases, nil)
                    }else{
                        canvasesCompletionHandler(nil, "Can not cast to Canvases" as? Error)
                    }
                } catch let error {
                    canvasesCompletionHandler(nil, error)
                }
            case let .failure(error):
                canvasesCompletionHandler(nil, error)
            }
        }
    }
    
    func addTextToCanvas(text: String, textCompletionHandler: @escaping (CanvasText?, Error?)-> Void){
        let bluescapeAPIProvider = NetworkManager.provider
        bluescapeAPIProvider.request(.addTextToCanvas(workspaceId: String(APIKeys.bluescapeAPIWorkspaceID),
                                                      canvasId: String(APIKeys.defaultCanvas),
                                                      width: 500,
                                                      height: 500,
                                                      text: text,
                                                      fontColor: MoleskineStyles.fontColor,
                                                      fontFamily: MoleskineStyles.fontFamily,
                                                      fontStyle: MoleskineStyles.fontStyle,
                                                      textTransform: MoleskineStyles.textTransform,
                                                      backgroundColor: MoleskineStyles.backgroundColor,
                                                      pin: false)) { result in
                                                        switch result {
                                                        case let .success(moyaResponse):
                                                            do{
                                                                let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                                                                let canvasesResult = try filteredResponse.map(CanvasText.self)
                                                                if let canvasText = canvasesResult as CanvasText?{
                                                                    textCompletionHandler(canvasText, nil)
                                                                    self.statusText.text = "Posted Text to Bluescape Canvas: \(String(APIKeys.defaultCanvas))"
                                                                }else{
                                                                    textCompletionHandler(nil, "Can not cast to Canvas Text" as? Error)
                                                                }
                                                            } catch let error {
                                                                textCompletionHandler(nil, error)
                                                            }
                                                        case let .failure(error):
                                                            textCompletionHandler(nil, error)
                                                        }
        }
    }
    
    func addImageToCanvas(image: Data, imageCompletionHandler: @escaping (CanvasImage?, Error?) -> Void){
        let bluescapeAPIProvider = NetworkManager.provider
        bluescapeAPIProvider.request(.addImageToCanvas(workspaceId: String(APIKeys.bluescapeAPIWorkspaceID),
                                                       canvasId: String(APIKeys.defaultCanvas),
                                                       x: 100,
                                                       y: 100,
                                                       url: "",
                                                       image: image,
                                                       pin: false,
                                                       scale: 1)) { result in
                                                        switch result {
                                                        case let .success(moyaResponse):
                                                            do{
                                                                let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                                                                let canvasesResult = try filteredResponse.map(CanvasImage.self)
                                                                if let canvasImage = canvasesResult as CanvasImage?{
                                                                    imageCompletionHandler(canvasImage, nil)
                                                                    self.statusText.text = "Posted Image to Bluescape Canvas: \(String(APIKeys.defaultCanvas))"
                                                                }else{
                                                                    imageCompletionHandler(nil, "Can not cast to Canvas Image" as? Error)
                                                                }
                                                            } catch let error {
                                                                imageCompletionHandler(nil, error)
                                                            }
                                                        case let .failure(error):
                                                            imageCompletionHandler(nil, error)
                                                        }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        statusText.text = ""
    }
}
