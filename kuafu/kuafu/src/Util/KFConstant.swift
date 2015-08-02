//
//  KFConstant.swift
//  kuafu
//
//  Created by Vienta on 15/6/6.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//  后期此文件需要分

import UIKit

// MARK: - Macro
let KF_THEME_COLOR:UIColor = UIColor(red: 0, green: 0.78, blue: 0, alpha: 1)
let KF_ICON_BG_COLOR:UIColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1)
let KF_BG_COLOR:UIColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1)
let KF_LINE_COLOR:UIColor = UIColor(red:0.85, green:0.85, blue:0.86, alpha:1)

let DEVICE_WIDTH:CGFloat = UIScreen.mainScreen().bounds.width
let DEVICE_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.height

let APP_VERSION:String! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
let APP_DISPLAY_NAME:String! = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as? String
let APP_BUNDLE_ID:String! = NSBundle.mainBundle().bundleIdentifier
let APP_BUILD_VERSION:String! = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String

// MARK: - Constant
let KF_LOCAL_NOTIFICATION_CATEGORY_REMIND = "KF_REMIND_CATEGORY"    //提醒
let KF_LOCAL_NOTIFICATION_CATEGORY_COMPLETE = "KF_COMPLETE_CATEGORY"//完成

// MARK: - Notification
let KF_NOTIFICATION_UPDATE_TASK = "KFNotificationUpdateTask"
let KF_NOTIFICATION_SHAKE = "KFNotificationShake"
let KF_NOTIFICATION_SHAKE_VALUE_CHANGED = "KFNotificationShakeValueChanged"

// MARK: - WatchKit
let KF_WK_OPEN_PARENT_APPLICATION_NEW_TASK = "newTask"
let KF_WK_OPEN_PARENT_APPLICATION_DELETE_TASK = "deleteTask"
let KF_WK_OPEN_PARENT_APPLICATION_ARCHIVE_TASK = "archiveTask"

// MARK: - Handoff
let KF_HANDOFF_ACTIVITY_TYPE = "com.vienta.kuafu.handoff"
let KF_HANDOFF_ACTIVITY_KEY = "kuafu.handoff.key"

// MARK: - SettingsKey
let KF_EVENTKIT_ACCEES_GRANTED = "KFEventKitAccessGrandted"
let KF_EVENTKIT_SELECTED_CALENDAR = "KFEventKitSelectedCalendar"
let KF_EVENTKIT_CAL_IDENTIFIERS = "KFEventKitCalIdentifiers"
let KF_SHAKE_CREATE_TASK = "KFShakeCreateTask"  //摇一摇新建任务
let KF_FEEDBACK = "KFFeedBack"                  //意见反馈
let KF_EVALUATION = "KFEvaluation"              //我要点评
let KF_ABOUT_KUAFU = "KFAboutKuaFu"             //关于夸父
let KF_HISTORY_VERSION = "KFHistoryVersion"     //历史版本
let KF_LISENCE = "KFLisence"                    //开源许可

// MARK: - AppConfig
let KF_MY_EMAIL = "yongxingshu@foxmail.com"
let KF_MY_BLOG = "http://www.vienta.me/"
let KF_PROJECT_URL = "https://github.com/Vienta/kuafu"
let KF_GROUP_ID = "group.com.vienta.kuafu.watch"
let KF_ITUNES_ITEM_IDENTIFIER = "1024927740"

// MARK: - Enum
enum kTapStyle :Int {
    case Alert
    case DateTo
}

enum KEventStatus :Int {
    case Normal
    case Delete
    case Achieve
    case Overdue
}

// MARK: - Global Methods
var KF_SETTINGS: Dictionary<String, String> = [
    KF_SHAKE_CREATE_TASK:"KF_SETTINGS_SHAKE_NEW_TASK".localized,
    KF_FEEDBACK:"KF_SETTINGS_FEEDBACK".localized,
    KF_EVALUATION:"KF_SETTINGS_EVALUATION".localized,
    KF_ABOUT_KUAFU:"KF_SETTINGS_ABOUT_KUAFU".localized,
    KF_HISTORY_VERSION:"KF_SETTINGS_HISTORY_VERSION".localized,
    KF_LISENCE:"KF_SETTINGS_LISENCE".localized]

func SAFE_OBJC(objc: AnyObject!) -> AnyObject {
    if (objc == nil){
        return NSNull()
    }
    return objc
}

func LOAD_NIB(nibName: String) -> AnyObject {
    return LOAD_NIB(nibName, 0)
}

func LOAD_NIB(nibName: String, index: Int) -> AnyObject {
    return NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)[index]
}

func DELAY(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}



class KFConstant: NSObject {
   
}
