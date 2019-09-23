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
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var previewText: UILabel!
    
    var selectedImages: [UIImage] = []
    
    var imagesData: [Data] = []
    
    @IBAction func cancelAction(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    @IBAction func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Picked Images"
        self.manageImages()
        print("extension loaded")
    }
    
    
    func redirectToHostApp() {
        let url = URL(string: "bluescapeShare://dataUrl=\(sharedKey)")
        print(url)
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
                            self.previewImage.image =  UIImage(data:imageData as Data,scale:1.0)
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
