//
//  KFMotionManager.swift
//  kuafu
//
//  Created by Vienta on 15/7/17.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import CoreMotion

private let sharedInstance = KFMotionManager()

class KFMotionManager: NSObject {
    
    var motion: CMMotionManager?
   
    class var sharedManager : KFMotionManager {
        return sharedInstance
    }
    
    override init() {
        super.init()
        self.motion = CMMotionManager()
        self.motion!.accelerometerUpdateInterval = 0.2
    }
    
    func startAccerometer() -> Void {
        self.stopAccerometer()
        self.motion?.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: { (accelerometerData, error) -> Void in
            let acc = accelerometerData as CMAccelerometerData
            self.outputAccelertionData(acc.acceleration)
            if (error != nil) {
                println("motion error:\(error)")
            }
        })
    }
    
    func outputAccelertionData(acceleration: CMAcceleration) ->Void {
        var accelerameter: Double = sqrt( pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
        if (accelerameter > 2.1) {
            if (NSUserDefaults.standardUserDefaults().boolForKey(KF_SHAKE_CREATE_TASK) == true) {
                NSNotificationCenter.defaultCenter().postNotificationName(KF_NOTIFICATION_SHAKE, object: nil)
            }
        }
    }
    
    func stopAccerometer() -> Void {
        self.motion?.stopAccelerometerUpdates()
    }
}
