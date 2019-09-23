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
    
    var cellItems: [CellModel] = []
    
    var imagePicker: UIImagePickerController?

    
    @IBAction func openPhoto(_ sender: Any) {
        self.present(self.imagePicker!, animated: true, completion: nil)
    }
    
    func test(){
        let authPlugin = AccessTokenPlugin {APIKeys.bluescapeAuthToken }
        let bluescapeAPIProvider = NetworkManager.provider
        let workspaceID = String(APIKeys.bluescapeAPIWorkspaceID)
        
        bluescapeAPIProvider.request(.getCanvases(workspaceId: workspaceID)) { result in
            switch result {
            case let .success(moyaResponse):

                do{
                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
                    let canvas = try filteredResponse.map(Canvas.self)
                } catch let error {
                    print("parse \(error)")
                }
            case let .failure(error):
                print(error)
            }
        }

        
//        bluescapeAPIProvider.request(.getCanvases(workspaceId: "")) {
//            result in
//            switch result{
//            case let .success(moyaResponse):
//                do{
//                    let filteredResponse = try moyaResponse.filterSuccessfulStatusCodes()
//                    self.canvas = try filteredResponse.map(Canvas.self)
//                }case let error{
//                print("Error")
//                }
//            case  .failure(error):{
//                    print("error")
//                }
//            }
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.sourceType = .photoLibrary
        self.imagePicker?.delegate = self
        test()
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        let model = CellModel(image: image)
        self.cellItems.append(model)
        // MARK: Upload the Selected Image
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
