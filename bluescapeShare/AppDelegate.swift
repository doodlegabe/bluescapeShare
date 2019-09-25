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
        // Override point for customization after application launch.
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
        if let key = url.absoluteString.components(separatedBy: "=").last{
            
            switch key {
                case storageItems.imageKey:
                    print("image")
                // retrieve from user defaults with key
                // Display
                // post to API
                case storageItems.textKey:
                    print("text")
                // retrieve from user defaults with key
                // Display
                // post to API
                default:
                    print("unknown")
            }
            
//            let sharedImage =  UserDefaults(suiteName: "group.com.brotherclone.bluescape.share")!.object(forKey: key) as? Data {
//            var imageArray: [CellModel] = []
//            let image = UIImage(data: sharedImage)!
//            let model = CellModel(image: image)
//            imageArray.append(model)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//
//            // MARK: Upload the Shared Image
//
//            homeVC.cellItems = imageArray
//            let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
//            navVC.viewControllers = [homeVC]
//            self.window?.rootViewController = navVC
//            self.window?.makeKeyAndVisible()
            return true
        }else{
            print("error parsing internal URL \(url)")
            return false
        }
    }
}
