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
}
