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
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    @IBOutlet weak var background: UIImageView!
    
    var cellItems: [CellModel] = []
    
    var imagePicker: UIImagePickerController?
    
    @IBAction func openPhoto(_ sender: Any) {
        self.present(self.imagePicker!, animated: true, completion: nil)
    }
    
    func getCanvases(canvasesCompletionHandler: @escaping (Canvases?, Error?) -> Void){
        let bluescapeAPIProvider = NetworkManager.provider
        let workspaceID = String(APIKeys.bluescapeAPIWorkspaceID)
        bluescapeAPIProvider.request(.getCanvases(workspaceId: workspaceID)) { result in
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
        let workspaceID = String(APIKeys.bluescapeAPIWorkspaceID)
        let canvasId = String(APIKeys.defaultCanvas)
        bluescapeAPIProvider.request(.addTextToCanvas(workspaceId: workspaceID,
                                                      canvasId: canvasId,
                                                      width: 500,
                                                      height: 500,
                                                      text: text,
                                                      fontFamily: "Dosis",
                                                      fontStyle: "normal",
                                                      textTransform: "inherit",
                                                      backgroundColor: "#ffffff",
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
   
    
    func uploadImage(image: UIImage){
        print("\n \n sharedimage \n \n")
        print(image)
    }
    

    func uploadText(text: String){
        print("\n \n text \n \n")
        print(text)
        
        addTextToCanvas(text: text, textCompletionHandler:{ canvasText, error in
             if let responseText = canvasText {
                print("\n\n\n back from bluescape")
             }
         })
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.sourceType = .photoLibrary
        self.imagePicker?.delegate = self
//        getCanvases(canvasesCompletionHandler: {canvases, error in
//            if let canvases = canvases {
//                // MARK: Can add canvas selection here later.
//                let currentCanvas: Canvas = canvases.canvas[0] as Canvas
//            }
//        })
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let imageData = UserDefaults(suiteName: "group.com.brotherclone.bluescape.share")!.object(forKey: storageItems.imageKey) as? Data{
            print("got imaage")
            let retrievedImage = UIImage(data: imageData)
        }
        
        let model = CellModel(image: image)
        self.cellItems.append(model)
        self.imgCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
        cell.item = self.cellItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dimension = (self.view.frame.size.width - 40)/3
        return CGSize(width: dimension, height: dimension)
    }
    
}


