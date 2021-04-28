//
//  AppDelegate.swift
//  muber-v2
//
//  Created by LucySD on 2021/04/19.
//

import UIKit
import Firebase

var loadedNumber = 1

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // comment something


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("\(loadedNumber). AppDelegate > application is loaded.")
        loadedNumber += 1
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("\(loadedNumber). AppDelegate > configurationForConnecting is loaded.")
        loadedNumber += 1
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        print("\(loadedNumber). AppDelegate > didDiscardSceneSessions is loaded.")
        loadedNumber += 1
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


