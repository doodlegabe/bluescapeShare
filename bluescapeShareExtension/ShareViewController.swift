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

enum sharingType{
    case text
    case image
}

class ShareViewController: UIViewController {
    
    @IBOutlet weak var previewImage: UIImageView!
    
    @IBOutlet weak var previewText: UILabel!
    
    var selectedImages: [UIImage] = []
    
    var imagesData: [Data] = []
    
    var currentSharingType: sharingType = .image
    
    @IBAction func cancelAction(_ sender: Any) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.redirectToHostApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageAttachments()
    }
    
    func redirectToHostApp() {
        var url:URL
        switch currentSharingType {
            case .image:
                url = URL(string: "bluescapeShare://dataUrl=\(storageItems.imageKey)")!
            case .text:
                url = URL(string: "bluescapeShare://dataUrl=\(storageItems.textKey)")!
        }
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
    
    func manageAttachments() {
        
        let content = extensionContext?.inputItems[0] as! NSExtensionItem
        
        let imageContentType = kUTTypeImage as String
        
        let textContentType = kUTTypeText as String
        
        for attachment in content.attachments! {
            
             if attachment.hasItemConformingToTypeIdentifier(imageContentType) {
                attachment.loadItem(forTypeIdentifier: imageContentType, options: nil) {
                    data, error in
                    if error == nil {
                        let url = data as! NSURL
                        if let imageData = NSData(contentsOf: url as URL) {
                            self.previewImage.image =  UIImage(data:imageData as Data,scale:1.0)
                            self.currentSharingType = .image
                            
                            // Convert to png/jpeg data
                            // save to user defaults with key
                        }
                    } else {
                        print(error)
                    }
                }
            }
            
            if attachment.hasItemConformingToTypeIdentifier(textContentType){
                attachment.loadItem(forTypeIdentifier: textContentType, options: nil) {
                    data, error in
                    if error == nil {
                        let url = data as! NSURL
                        print(url)
                         if let textData = NSData(contentsOf: url as URL) {
                            let datastring = NSString(data: textData as Data, encoding: String.Encoding.utf8.rawValue)
                            self.previewText.text = String(datastring!)
                            self.currentSharingType = .text
                            
                            // save to user defaults with key
                        }
                    } else{
                        print(error)
                    }
                }
            }
        }
    }
}
