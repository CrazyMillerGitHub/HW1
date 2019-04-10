//
//  AppDelegate.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit
import CoreData
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Theme.current.apply()
        if UserDefaults.standard.string(forKey: "profileLabel") != nil { } else { UserDefaults.standard.set("StandartUser", forKey: "profileLabel") }
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        UINavigationBar.appearance().shadowImage = UIImage()
        checkAvailableAppUser()
        Logger.SharedInstance.log(message: "Application moved from Not Running to Inactive: \(#function)")
        return true
    }
    
    private func checkAvailableAppUser() {
        if AppUser.requestAppUser(in: StorageManager.Instance.coreDataStack.mainContext) == nil {
            generateCurrectUser()
        }
    }
    
    private func generateCurrectUser() {
        StorageManager.Instance.coreDataStack.saveContext.performAndWait {
            
            let user = AppUser.findOrInsertAppUser(in: StorageManager.Instance.coreDataStack.saveContext)
            if let user = user {
                user.currentUser?.name = "defaultUser"
                user.currentUser?.userID = NSUUID().uuidString.lowercased()
            }
            StorageManager.Instance.coreDataStack.performSave()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.SharedInstance.log(message: "Application moved from Actvie to Inactive: \(#function)")
        
        //
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.SharedInstance.log(message: "Application moved from Inactive to Background: \(#function)")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.SharedInstance.log(message: "Application moved from Background to Inactive: \(#function)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.SharedInstance.log(message: "Application moved from Inactive to Active: \(#function)")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.SharedInstance.log(message: "Application moved from Bacground to Terminated: \(#function)")
    }
    
}
