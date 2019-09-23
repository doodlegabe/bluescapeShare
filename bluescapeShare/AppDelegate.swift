//
//  AppDelegate.swift
//  bluescapeShare
//
//  Created by Gabriel Walsh on 9/20/19.
//  Copyright © 2019 Gabriel Walsh. All rights reserved.
//

import UIKit

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
        let userDefaults = UserDefaults(suiteName: "group.com.brotherclone.bluescape.share")
        if let key = url.absoluteString.components(separatedBy: "=").last,
            let sharedArray = userDefaults?.object(forKey: key) as? [Data] {
            
            var imageArray: [CellModel] = []
            
            for imageData in sharedArray {
                let model = CellModel(image: UIImage(data: imageData)!)
                imageArray.append(model)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            homeVC.cellItems = imageArray
            let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            navVC.viewControllers = [homeVC]
            self.window?.rootViewController = navVC
            self.window?.makeKeyAndVisible()
            return true
        }else{
            return false
        }
    }
}
