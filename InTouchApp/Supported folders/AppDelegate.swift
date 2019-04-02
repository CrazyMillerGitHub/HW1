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
    setup("Veronika")
//    let results = result.last!.users!.allObjects as! [User]
//    results.forEach {print($0.name)}
//    let request2: NSFetchRequest<User> = User.fetchRequest()
//    guard let result2 = try? StorageManager.Instance.coreDataStack.mainContext.fetch(request2) else {fatalError("Fetch failded")}
//    print(result2)
//    result2.forEach {print(($0.users?.allObjects as! [User]))}
    Logger.SharedInstance.log(message: "Application moved from Not Running to Inactive: \(#function)")
    return true
  }
    func setup(_ name: String) {
//        let user = AppUser.findOrInsertAppUser(in: StorageManager.Instance.coreDataStack.mainContext)
        let user2 = User.insertUser(in: StorageManager.Instance.coreDataStack.mainContext)
//        if let use3 = user {
//            use3.currentUser?.name = name
//        }
        //Сохранение пользователя
        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
   guard let result = try? StorageManager.Instance.coreDataStack.mainContext.fetch(request) else {fatalError("Fetch failded")}
        user2?.name = name
        user2?.userID = name + UIDevice.current.name
        if let user1 = user2 {
            result.last?.addToUsers(user1)
        }
        do { try StorageManager.Instance.coreDataStack.performSave(with: StorageManager.Instance.coreDataStack.mainContext) } catch {}
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
