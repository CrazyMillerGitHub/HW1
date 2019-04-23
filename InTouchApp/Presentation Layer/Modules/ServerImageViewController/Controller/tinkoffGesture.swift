//
//  tinkoffGesture.swift
//  InTouchApp
//
//  Created by Михаил Борисов on 23/04/2019.
//  Copyright © 2019 Mikhail Borisov. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass
import UIKit
//
//class tinkoffGesture: UIGestureRecognizer {
//    
//    var force: CGFloat { return trackingTouch?.force ?? 0.0 }
//    
//    private let forceThreshold: CGFloat
//    private var trackingTouch: UITouch?
//    
//    init(forceThreshold: CGFloat) {
//        self.forceThreshold = forceThreshold
//        super.init(target: nil, action: nil)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
//        if let trackingTouch = trackingTouch {
//            touches.filter { $0 !== trackingTouch }.forEach { ignore($0, for: event) }
//        } else if let touch = touches.first {
//            trackingTouch = touch
//        } else {
//            state = .failed
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
//        guard let trackingTouch = trackingTouch, touches.contains(where: { $0 === trackingTouch }) else { return }
//        
//        if trackingTouch.force >= forceThreshold || state == .changed {
//            if state == .possible || state == .ended {
//                state = .began
//            }
//            
//            state = .changed
//        }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
//        guard touches.contains(where: { $0 === trackingTouch }) && (state == .began || state == .changed) else { return }
//        trackingTouch = nil
//        state = .cancelled
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
//        guard touches.contains(where: { $0 === trackingTouch }) && (state == .began || state == .changed)  else { return }
//        trackingTouch = nil
//        state = .ended
//    }
//    
//    override func reset() {
//        trackingTouch = nil
//        state = .possible
//    }
//    
//}
