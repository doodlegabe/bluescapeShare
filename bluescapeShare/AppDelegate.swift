//
//  AppDelegate.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/20/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit
import Moya


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

extension AppDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navVC.viewControllers = [homeVC]
            self.window?.rootViewController = navVC
            if let key = url.absoluteString.components(separatedBy: "=").last{
                    switch key {
                        case storageItems.imageKey:
                        if let imageData = UserDefaults(suiteName: "group.com.brotherclone.bluescape.share")!.object(forKey: storageItems.imageKey) as? Data{
                               let retrievedImage = UIImage(data: imageData)
                            homeVC.addImageToCanvas(image: imageData) { canvasImage, error in
                            if let responseImage = canvasImage {
                                print("\n\n\n back from bluescape \(responseImage)")
                                }
                            }
                           }
                        case storageItems.textKey:
                        if let textData = UserDefaults(suiteName: "group.com.brotherclone.bluescape.share")!.object(forKey: storageItems.textKey) as? String {
                            homeVC.addTextToCanvas(text: textData, textCompletionHandler:{ canvasText, error in
                                    if let responseText = canvasText {
                                       print("\n\n\n back from bluescape \(responseText)")
                                    }
                                })
                        }
                        default:
                            print("unknown")
                    }
            self.window?.makeKeyAndVisible()
            return true
        }else{
            print("error parsing internal URL \(url)")
            return false
        }
    }
}
