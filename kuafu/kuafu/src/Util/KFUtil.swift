//
//  KFUtil.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFUtil: NSObject {
   
    class func documentFilePath(fileName: String) -> String {
        var filePath =  NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(fileName)
        return filePath
    }
    
    class func skipBackupAttributeToItemAtPath(URL: NSURL) -> Bool {
        URL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey, error: nil)
        return true
    }
    
    class func getCurrentTime() -> Double {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        var locale: NSLocale = NSLocale(localeIdentifier: "en_GB")
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //hh:12小时 HH:24小时
        
        var currentDate: NSDate = NSDate()
        
        return currentDate.timeIntervalSince1970
    }
    
    class func drawCircleView(view: UIView) {
        self.drawCircleView(view, borderColor: UIColor.clearColor(), borderWidth: 0.0)
    }
    
    class func drawCircleView(view: UIView ,borderColor: UIColor ,borderWidth:CGFloat) {
        view.layer.cornerRadius = CGRectGetMidX(view.bounds)
        view.layer.masksToBounds = true
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor.CGColor
    }
    class func drawCornerView(view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle:NSBundle.mainBundle(), value: "", comment: "")
    }
}