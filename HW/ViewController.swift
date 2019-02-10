//
//  ViewController.swift
//  HW
//
//  Created by Михаил Борисов on 08/02/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    Log.check("Is logging = \(StruckOfLog.isLogging)")
  }
  override func viewWillAppear(_ animated: Bool) {
    Log.check("Application moved from DidLoad to Appearing: \(#function)")
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
   Log.check("Application moved from DidLayoutSubviews to Appeared: \(#function)")
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    Log.check("Application moved from Appearing to WillLayoutSubviews: \(#function)")
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    Log.check("Application moved from WillLayoutSubviews to DidLayoutSubviews: \(#function)")
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    Log.check("5")
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
    Log.check("6")
  }
}


