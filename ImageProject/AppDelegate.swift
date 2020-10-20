//
//  AppDelegate.swift
//  ImageProject
//
//  Created by 刘胜 on 2020/10/9.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let navi = UINavigationController.init(rootViewController: ViewController())
        window.rootViewController = navi
        window.makeKeyAndVisible()
        return true
    }



}

