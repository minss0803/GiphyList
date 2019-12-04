//
//  AppDelegate.swift
//  GiphyList
//
//  Created by 민쓰 on 02/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import UIKit
import Then
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        let mainViewController = MainViewController()
        let mainViewModel = MainViewModel()
        mainViewController.bind(mainViewModel)
        
        let navigationViewController = UINavigationController(rootViewController: mainViewController)
        navigationViewController.do {
            $0.isNavigationBarHidden = true
        }
        
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }

   

}

