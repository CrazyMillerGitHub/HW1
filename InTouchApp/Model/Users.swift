//
//  Users.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//
// DEPRECETAED CLASS
//
//import UIKit
//
//class Users {
//  static var sharedInstance = Users()
//  init() {}
//
//  func configureUsers() -> [[[Any?]]] {
//    var arr: [[[Any]]] = []
//    arr.append(onlineUsers())
//    arr.append(historyUsers())
//    return arr
//  }
//  func onlineUsers()-> [[Any]] {
//    var onlineArray: [[Any]] = []
//    onlineArray.append(["Mike", "Я здесь", "2019-1-14T07:59:00", true, false])
//    onlineArray.append(["Джэйн", "Как дела?", "2019-2-24T17:59:00", true, true])
//    onlineArray.append(["Сэм", "Что с тобой не так?", "2019-2-23T10:59:00", true, false])
//    onlineArray.append(["Ван", "Очень смешно...", "2016-02-29 12:24:26", true, false])
//    onlineArray.append(["Дэн", "Встретимся", "2019-2-14T17:59:00", true, false])
//    onlineArray.append(["Женя", "Я готова", "2019-2-11T17:59:00", true, false])
//    onlineArray.append(["Катя", "Я скучаю", "2019-2-24T17:59:00", true, false])
//    onlineArray.append(["Федя", "Уже подъезжаю", "2016-02-29 12:24:26", true, false])
//    onlineArray.append(["Маша", "Уходи", "2019-2-24T17:59:00", true, false])
//    onlineArray.append(["Таня", "Прости", "2019-2-20T17:59:00", true, true])
//    onlineArray.append(["Вика", "", "2019-2-24T15:59:00", true, false])
//    return onlineArray
//  }
//  func historyUsers()-> [[Any]] {
//    var historyArray: [[Any]] = []
//    historyArray.append(["Настя", "Нам нужно серъезно поговорить с тобой", "2019-1-14T07:59:00", false, true])
//    historyArray.append(["Саша", "Кукусики", "2019-2-17T17:48:00", false, false])
//    historyArray.append(["Амосов", "Где Сашенька", "2019-2-26T23:29:00", false, false])
//    historyArray.append(["Виктор", "Встреча в силе?", "2019-2-25T23:29:00", false, false])
//    historyArray.append(["Валя", "*$~/&*", "2019-2-25T17:29:00", false, true])
//    historyArray.append(["Соня", "Thx", "2019-2-25T17:29:00", false, true])
//    historyArray.append(["Виктор", "Встреча в силе?", "2019-2-25T23:29:00", false, false])
//    historyArray.append(["Валя", "*$~/&*", "2019-2-25T17:29:00", false, true])
//    historyArray.append(["Соня", "Thx", "2019-2-25T17:29:00", false, true])
//    historyArray.append(["Анна", "Thx", "2019-2-27T6:38:00", false, false])
//    return historyArray
//  }
//
//}
