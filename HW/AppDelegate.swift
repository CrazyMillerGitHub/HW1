//
//  AppDelegate.swift
//  HW
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    print("Application moved from Not Running to Inactive: \(#function)")
    return true
  }


  func applicationWillResignActive(_ application: UIApplication) {
    print("Application moved from Actvie to Inactive: \(#function)")
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    print("Application moved from Inactive to Background: \(#function)")
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    print("Application moved from Background to Inactive: \(#function)")
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    print("Application moved from Inactive to Active: \(#function)")
  }

  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

