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
        let filePath =  ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(fileName)
        return filePath
    }
    
    class func skipBackupAttributeToItemAtPath(URL: NSURL) -> Bool {
        do {
            try URL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
        } catch _ {
        }
        return true
    }
    
    class func getCurrentTime() -> Double {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let locale: NSLocale = NSLocale(localeIdentifier: "en_GB")
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" //hh:12小时 HH:24小时
        
        let currentDate: NSDate = NSDate()
        
        return currentDate.timeIntervalSince1970
    }
    
    class func dateFromTimeStamp(timeStamp: NSTimeInterval) -> NSDate {
        return NSDate(timeIntervalSince1970: timeStamp)
    }
    
    class func getShortDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.stringFromDate(date)
    }
    
    class func getDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    class func getTodayShortDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(date)
    }
    
    class func getDateByString(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.dateFromString(dateString)!
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