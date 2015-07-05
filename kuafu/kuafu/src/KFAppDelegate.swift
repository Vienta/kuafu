//
//  AppDelegate.swift
//  kuafu
//
//  Created by Vienta on 15/6/4.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

@UIApplicationMain
class KFAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = KF_THEME_COLOR
        UINavigationBar.appearance().tintColor = KF_THEME_COLOR
        
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
        
        let settings = UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: NSSet(array: [remindCategory, completeCategory]) as Set<NSObject>)
        application.registerUserNotificationSettings(settings)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("didReceiveLocalNotification:\(notification) alertBody:\(notification.alertBody)")
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        println("~~~identifier:\(identifier)")
        switch (identifier!) {
        case "GET_IT_TODO":
            println("GET_IT_TODO")
            break
        case "COMPLETE_TODO":
            println("COMPLETE_IT")
            var event: KFEventDO = KFLocalPushManager.sharedManager.getEventByNotification(notification)
            event.status = NSNumber(integerLiteral: KEventStatus.Achieve.rawValue)
            KFEventDAO.sharedManager.saveEvent(event)
            break
        case "DELETE_TODO":
            println("DELETE_TODO")
            var event: KFEventDO = KFLocalPushManager.sharedManager.getEventByNotification(notification)
            event.status = NSNumber(integerLiteral: KEventStatus.Delete.rawValue)
            KFEventDAO.sharedManager.saveEvent(event)
            break
        case "DELAY_TODO":
            println("DELAY_TODO")
            var event: KFEventDO = KFLocalPushManager.sharedManager.getEventByNotification(notification)
            let alertBody: String = "KF_TASK_DUE_AFTER_FIVE_MIN".localized + ": " + event.content
            event.endtime = NSDate().dateByAddingTimeInterval(5 * 60).timeIntervalSince1970
            KFEventDAO.sharedManager.saveEvent(event)
            KFLocalPushManager.sharedManager.registerLocalPushWithFireDate(NSDate().dateByAddingTimeInterval(5 * 60), alertBody: alertBody, and: event.eventid, with: KF_LOCAL_NOTIFICATION_CATEGORY_COMPLETE)
            break
        default:
            println("Error: unexpected notification action identifier!")
        }
        
        completionHandler()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

/*
    UIView->v
    UITableView->tbv
    UIScrollView->scv
    UITextField->txf
    UITextView->txv
    UILabel->lbl
    UIButton->btn
*/