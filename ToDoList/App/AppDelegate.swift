//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private let storageManager = StorageManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storageManager.saveContext()
    }

}

