//
//  KFConstant.swift
//  kuafu
//
//  Created by Vienta on 15/6/6.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

// MARK: --Macro--
let KF_THEME_COLOR:UIColor = UIColor(red: 0, green: 0.78, blue: 0, alpha: 1)
let KF_ICON_BG_COLOR:UIColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 1)
let KF_BG_COLOR:UIColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
let DEVICE_WIDTH:CGFloat = UIScreen.mainScreen().bounds.width
let DEVICE_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.height

// MARK: --Notification--
let KF_NOTIFICATION_UPDATE_TASK = "KFNotificationUpdateTask"


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

class KFConstant: NSObject {
   
}
