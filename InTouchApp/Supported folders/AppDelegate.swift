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
let coreData = CoreDataStack()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      Theme.current.apply()
    if UserDefaults.standard.string(forKey: "profileLabel") != nil { } else { UserDefaults.standard.set("StandartUser", forKey: "profileLabel") }
    print()
//   let user = AppUser.findOrInsertAppUser(in: coreData.saveContext)
//        user?.name = "Fred"
//        let model = coreData.managedObjectModel
//            let userr = AppUser.fetchRequestAppUser(model: model)
//    guard let userrr = userr else { fatalError() }
//    try! coreData.performSave(with: coreData.saveContext)
//    let result = try! coreData.mainContext.fetch(userrr)
//    print(result.last?.name)
//
//    ////
//    print(user?.name)
    /////////////////////////
    UINavigationBar.appearance().shadowImage = UIImage()
    Logger.SharedInstance.log(message: "Application moved from Not Running to Inactive: \(#function)")
    return true
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
