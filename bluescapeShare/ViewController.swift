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
        
    
    @IBOutlet weak var statusText: UILabel!
    
    @IBOutlet weak var viewOnBluescapeButton: UIButton!
    
    @IBAction func viewOnBluescape(_ sender: Any) {
        
    }
    
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
    
    func displayWebLink(){
        statusText.text = "Bluescape posting successful."
        viewOnBluescapeButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusText.text = "Awaiting text or image."
        viewOnBluescapeButton.setTitle("View on Bluescape", for: .normal)
        viewOnBluescapeButton.isHidden = true
        self.view.backgroundColor = UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBluescape",
            let nextViewController = segue.destination as? BluescapeWebViewController{
            let urlString = APIKeys.bluescapeWebBaseUrl + "/" + APIKeys.bluescapeAPIWorkspaceID
            nextViewController.bluescapeURL = URL(string:urlString)!
        }
    }
}
