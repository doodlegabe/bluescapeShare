//
//  ShareViewController.swift
//  bluescapeShareExtension
//
//  Created by Gabriel Walsh on 9/20/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {

    let sharedKey = "ImageSharePhotoKey"
    
    var selectedImages: [UIImage] = []
    var imagesData: [Data] = []
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    
    @IBAction func cancelAction(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    @IBAction func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgCollectionView.delegate = self
        self.imgCollectionView.dataSource = self
//        let attributes = [NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
//                          NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!] as! [String: Any]
//        
//        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationItem.title = "Picked Images"
        self.manageImages()
        print("extension loaded")
    }
    
    
    func redirectToHostApp() {
        let url = URL(string: "ImagePicker://dataUrl=\(sharedKey)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func manageImages() {
        
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        
        for attachment in content.attachments as! [NSItemProvider] {
             if attachment.hasItemConformingToTypeIdentifier(contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) {
                    data, error in
                    
                    if error == nil {
                        print("no error")
                        let url = data as! NSURL
                        print(url)
                        if let imageData = NSData(contentsOf: url as URL) {
                            self.selectedImages.append(UIImage(data: imageData as Data)!)
                        }
                    } else {
                        
                        let alert = UIAlertController(title: "Error", message: "Error loading image", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }

            }
        }
        }
    }
}


extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewWidth = UIScreen.main.bounds.size.width
        let width = (viewWidth - 40) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareImageCollectionCell", for: indexPath) as! ShareImageCollectionCell
        cell.configure(image: selectedImages[indexPath.row])
        return cell
    }
}

extension UIImage {
    class func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
