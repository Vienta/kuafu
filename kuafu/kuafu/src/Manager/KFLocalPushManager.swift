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
            self.registerLocalPushWithFireDate(alertDate, alertBody: alertBody, and: event.eventid, with: KF_LOCAL_NOTIFICATION_CATEGORY_REMIND)
        }
        
        if event.endtime != nil && event.endtime.doubleValue > 0 {
            if (event.endtime.doubleValue - NSDate().timeIntervalSince1970) > 300000 {
                var dueToDate: NSDate = KFUtil.dateFromTimeStamp(event.endtime.doubleValue - 300000) as NSDate
                var dueToBody: String = "KF_TASK_DUE_AFTER_FIVE_MIN".localized + ": " + event.content
                self.registerLocalPushWithFireDate(dueToDate, alertBody: dueToBody, and: event.eventid, with: KF_LOCAL_NOTIFICATION_CATEGORY_REMIND)
            }
        }
        
        if event.endtime != nil && event.endtime.doubleValue > 0 {
            var dueToDate: NSDate = KFUtil.dateFromTimeStamp(event.endtime.doubleValue) as NSDate
            var dueToBody: String = "KF_ALREADY_DUE".localized + ": " + event.content
            self.registerLocalPushWithFireDate(dueToDate, alertBody: dueToBody, and: event.eventid, with: KF_LOCAL_NOTIFICATION_CATEGORY_COMPLETE)
        }
        
        return true
    }

    func registerLocalPushWithFireDate(fireDate: NSDate, alertBody: String, and eventid: NSNumber!, with type: String) -> Void {
        
        var localNoti: UILocalNotification = UILocalNotification()
        localNoti.fireDate = fireDate
        localNoti.timeZone = NSTimeZone.defaultTimeZone()
        
        localNoti.alertBody = alertBody
        localNoti.soundName = UILocalNotificationDefaultSoundName
        
        var userDict: NSDictionary?
        if eventid.longLongValue <= 0 {
            userDict = ["content": "\(fireDate)\(alertBody)"]
        } else {
            userDict = ["content": "\(fireDate)\(alertBody)","eventid": eventid]
        }
        
        println("userDict\(userDict)")
        
        localNoti.userInfo = userDict as? [NSObject : AnyObject]
        localNoti.category = type
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNoti)
    }
    
    func allLocalPush() -> NSArray {
        return UIApplication.sharedApplication().scheduledLocalNotifications
    }
    
    func cancelAllLocal() -> Void {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func deleteLocalPushWithEvent(event: KFEventDO) -> Bool {
        var targetNotifications: NSMutableArray = NSMutableArray(capacity: 0) as NSMutableArray
        
        for notifcation in UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification] {
            var userDict: NSDictionary = notifcation.userInfo!
            var eventid: NSNumber = userDict.objectForKey("eventid") as! NSNumber
            if eventid.longLongValue > 0 {
                if eventid.longLongValue == event.eventid.longLongValue {
                    targetNotifications.addObject(notifcation)
                }
            }
        }
        
        if targetNotifications.count > 0 {
            for targetNoti in targetNotifications {
                UIApplication.sharedApplication().cancelLocalNotification(targetNoti as! UILocalNotification)
            }
            return true
        } else {
            return false
        }
    }
    
    func getEventByNotification(notification: UILocalNotification) -> KFEventDO {
        var userDict: NSDictionary = notification.userInfo!
        var eventid: NSNumber = userDict.objectForKey("eventid") as! NSNumber
        var event: KFEventDO = KFEventDAO.sharedManager.getEventById(eventid)!
        
        return event
    }
    
    func localNotificationSettingsCategories() -> NSSet {
        let completeAction = UIMutableUserNotificationAction()
        completeAction.identifier = "COMPLETE_TODO";
        completeAction.title = "KF_LOCALNOTIFICATION_COMPLETE".localized
        completeAction.activationMode = .Background
        completeAction.authenticationRequired = false
        completeAction.destructive = true
        
        let getitAction = UIMutableUserNotificationAction()
        getitAction.identifier = "GET_IT_TODO"
        getitAction.title = "KF_LOCALNOTIFICATION_GET_IT".localized
        getitAction.activationMode = .Background
        getitAction.destructive = false
        
        let deleteAction = UIMutableUserNotificationAction()
        deleteAction.identifier = "DELETE_TODO"
        deleteAction.title = "KF_DELETE".localized
        deleteAction.activationMode = .Background
        deleteAction.destructive = false
        
        let delayAction = UIMutableUserNotificationAction()
        delayAction.identifier = "DELAY_TODO"
        delayAction.title = "KF_LOCALNOTIFICATION_FIVE_MIN_AFTER".localized
        delayAction.activationMode = .Background
        deleteAction.destructive = false
        
        let remindCategory = UIMutableUserNotificationCategory()
        remindCategory.identifier = KF_LOCAL_NOTIFICATION_CATEGORY_REMIND
        remindCategory.setActions([getitAction, deleteAction], forContext: .Default)
        
        let completeCategory = UIMutableUserNotificationCategory()
        completeCategory.identifier = KF_LOCAL_NOTIFICATION_CATEGORY_COMPLETE
        completeCategory.setActions([delayAction, completeAction, deleteAction], forContext: .Default)
        
        var categoriesSet: NSSet = NSSet(array: [remindCategory, completeCategory])
        return categoriesSet
    }
}
