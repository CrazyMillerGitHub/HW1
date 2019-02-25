//
//  Users.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 22/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit


class Users{
  static var sharedInstance = Users()
  init(){}
  
  func configureUsers() -> [[[Any?]]] {
    var arr : [[[Any]]] = []
    arr.append(onlineUsers())
    arr.append(historyUsers())
    return arr
  }
  func onlineUsers()-> [[Any]] {
    var onlineArray: [[Any]] = []
    onlineArray.append(["Mike", "Я здесь","2019-1-14T07:59:00",true ,false])
    onlineArray.append(["Джэйн", "Как дела?","2019-2-24T17:59:00",true ,true])
    onlineArray.append(["Сэм", "Что с тобой не так?","2019-2-23T10:59:00",true ,false])
    onlineArray.append(["Ван", "Очень смешно...","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Дэн", "Встретимся","2019-2-14T17:59:00",true ,false])
    onlineArray.append(["Женя", "Я готова","2019-2-11T17:59:00",true ,false])
    onlineArray.append(["Катя", "Я скучаю","2019-2-24T17:59:00",true ,false])
    onlineArray.append(["Федя", "Уже подъезжаю","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Маша", "Уходи","2019-2-24T17:59:00",true ,false])
    onlineArray.append(["Таня", "Прости","2019-2-20T17:59:00",true ,true])
    onlineArray.append(["Вика","","2019-2-24T15:59:00",true ,false])
    return onlineArray
  }
  func historyUsers()-> [[Any]]{
    var historyArray: [[Any]] = []
    historyArray.append(["Настя", "Нам нужно серъезно поговорить с тобой","2019-1-14T07:59:00",false ,true])
    historyArray.append(["Саша", "Кукусики","2019-2-17T17:48:00",false ,false])
    historyArray.append(["Амосов", "Где Сашенька","2019-2-26T23:29:00",false ,false])
    historyArray.append(["Виктор", "Встреча в силе?","2019-2-25T23:29:00",false ,false])
    historyArray.append(["Валя", "*$~/&*","2019-2-25T17:29:00",false ,true])
    historyArray.append(["Соня", "Thx","2019-2-25T17:29:00",false ,true])
    historyArray.append(["Виктор", "Встреча в силе?", "2019-2-25T23:29:00", false, false])
    historyArray.append(["Валя", "*$~/&*", "2019-2-25T17:29:00", false, true])
    historyArray.append(["Соня", "Thx", "2019-2-25T17:29:00", false, true])
    historyArray.append(["Анна", "Thx", "2019-2-27T6:38:00", false, false])
//    for _ in 0..<4{
//    historyArray.append(generate(onlineStatus: false))
//    }
    return historyArray
  }
//  private func generate(onlineStatus: Bool) -> [Any]{
//    let name = ["Анастасия", "Мария" ,"Дарья", "Анна","Елизавета","Полина", "Виктория", "Екатерина", "Софья", "Александра"]
//    let message = ["Кукусики","Где Сашенька?", "Встреча в силе?", "*$~/&*", "Thx"]
//    return [name.randomElement()!,message.randomElement()!, "2019-2-\(Int.random(in: 25...27))T\(Int.random(in: 0...23)):\(Int.random(in: 0...59)):00",onlineStatus,Bool.random()]
//  }
}
