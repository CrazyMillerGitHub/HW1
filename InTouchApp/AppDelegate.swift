//
//  AppDelegate.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    //Включение и выключение вывода в консоль
    StruckOfLog.isLogging = true
    Logging().check("Application moved from Not Running to Inactive: \(#function)")
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    Logging().check("Application moved from Actvie to Inactive: \(#function)")
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    Logging().check("Application moved from Inactive to Background: \(#function)")
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    Logging().check("Application moved from Background to Inactive: \(#function)")
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    Logging().check("Application moved from Inactive to Active: \(#function)")
  }

  func applicationWillTerminate(_ application: UIApplication) {
     Logging().check("Application moved from Bacground to Terminated: \(#function)")
  }

}

