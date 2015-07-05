//
//  KFLocalPushManager.swift
//  kuafu
//
//  Created by Vienta on 15/7/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

private let sharedInstance = KFLocalPushManager()

class KFLocalPushManager: NSObject {
    
    class var sharedManager: KFLocalPushManager {
        return sharedInstance
    }
    
    func registerLocaPushWithEvent(event: KFEventDO) -> Bool {
        
        if event.starttime != nil && event.starttime.doubleValue > 0 {
            var alertDate: NSDate = KFUtil.dateFromTimeStamp(event.starttime.doubleValue) as NSDate
            var alertBody: String = event.content
            self.registerLocalPushWithFireDate(alertDate, and: alertBody)
        }
        
        if event.endtime != nil && event.endtime.doubleValue > 0 {
            var dueToDate: NSDate = KFUtil.dateFromTimeStamp(event.endtime.doubleValue - 300000) as NSDate
            var dueToBody: String = "KF_TASK_DUE_AFTER_FIVE_MIN".localized + ": " + event.content
            self.registerLocalPushWithFireDate(dueToDate, and: dueToBody)
        }
        
        if event.endtime != nil && event.endtime.doubleValue > 0 {
            var dueToDate: NSDate = KFUtil.dateFromTimeStamp(event.endtime.doubleValue) as NSDate
            var dueToBody: String = "KF_ALREADY_DUE".localized + ": " + event.content
            self.registerLocalPushWithFireDate(dueToDate, and: dueToBody)
        }

        return true
    }

    func registerLocalPushWithFireDate(fireDate: NSDate, and alertBody: String) -> Void {
        
        var localNoti: UILocalNotification = UILocalNotification()
        localNoti.fireDate = fireDate
        localNoti.timeZone = NSTimeZone.defaultTimeZone()
        
        localNoti.alertBody = alertBody
        localNoti.soundName = "sms.caf"
        
        var userDict: NSDictionary = ["uid": "\(fireDate)\(alertBody)"]
        println("userDict\(userDict)")
        
        localNoti.userInfo = userDict as [NSObject : AnyObject]
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNoti)
    }
}
