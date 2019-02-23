//
//  User.swift
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
    onlineArray.append(["Mike", "Я здесь","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Джэйн", "Как дела?","2016-02-29 12:24:26",true ,true])
    onlineArray.append(["Сэм", "Что с тобой не так?","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Ван", "Очень смешно...","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Дэн", "Встретимся","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Женя", "Я готова","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Катя", "Я скучаю","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Федя", "Уже приезжаю","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Маша", "Уходи","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Таня", "Прости","2016-02-29 12:24:26",true ,false])
    onlineArray.append(["Вика", "Привет","2016-02-29 12:24:26",true ,false])
    return onlineArray
  }
  func historyUsers()-> [[Any]]{
    return [["hh"]]
  }
}
