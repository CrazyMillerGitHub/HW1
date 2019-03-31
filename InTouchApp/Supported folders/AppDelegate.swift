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
//print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
//    let model = StorageManager.Instance.coreDataStack.managedObjectModel
//    let userr = AppUser.fetchRequestAppUser(model: model)
//    guard let userrr = userr else { fatalError() }
//     do { let result = try StorageManager.Instance.coreDataStack.mainContext.fetch(userrr)
//        print(result.last?.descriptionLabel)
//     } catch {fatalError()}
//   setup("Vicktor")
//  insertUsers()
//  returnFunc()
    UINavigationBar.appearance().shadowImage = UIImage()
    Logger.SharedInstance.log(message: "Application moved from Not Running to Inactive: \(#function)")
    return true
  }
//    func insertUsers() {
//        guard let user1 = NSEntityDescription.insertNewObject(forEntityName: "User", into: StorageManager.Instance.coreDataStack.mainContext) as? User else {fatalError()}
//        user1.name = "Mike"
//        guard let user2 = NSEntityDescription.insertNewObject(forEntityName: "User", into: StorageManager.Instance.coreDataStack.mainContext) as? User else {fatalError()}
//        user2.name = "Friend"
////        guard let user3 = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: StorageManager.Instance.coreDataStack.mainContext) as? AppUser else {fatalError()}
////        user3.users?.name = "Valya"
////        guard let user4 = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: StorageManager.Instance.coreDataStack.mainContext) as? AppUser else {fatalError()}
////        user4.users?.name = "Sonya"
//        do {
//            try(StorageManager.Instance.coreDataStack.mainContext.save())
//        }catch {
//            print(error.localizedDescription)
//        }
//    }
//    func returnFunc() {
//      //  let request = NSFetchRequest<NSDictionary>(entityName: "User")
//        let request: NSFetchRequest<AppUser> = AppUser.fetchRequest()
//        let request2: NSFetchRequest<User> = User.fetchRequest()
////        request.resultType = .dictionaryResultType
//        do {
//            let result = try StorageManager.Instance.coreDataStack.mainContext.fetch(request)
//             result.forEach {print($0.users)}
//            let result2 = try StorageManager.Instance.coreDataStack.mainContext.fetch(request2)
//            print(result2.count)
//            result2.forEach {print($0)}
//        } catch { print(error.localizedDescription) }
//    }
//    func setup(_ name: String) {
//        let user = AppUser(context: StorageManager.Instance.coreDataStack.saveContext)
//        user.name = name
//        do { try StorageManager.Instance.coreDataStack.performSave(with: StorageManager.Instance.coreDataStack.saveContext)} catch {}
//    }
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
