//
//  KFDBManager.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import FMDB

let SQLDOC = "iDoc"
let KF_EVENT_SQL = "KFEvent.sqlite"

private let sharedInstance = KFDBManager()

class KFDBManager: NSObject {
    
    var dbQueue: FMDatabaseQueue?
    
    class var sharedManager : KFDBManager {
        return sharedInstance
    }
    
    override init() {
        super.init()
        dbQueue = FMDatabaseQueue(path: self.databasePath())
    }
    
    func sqlPath() -> String {
        let docPath:String = KFUtil.documentFilePath(SQLDOC)
        let fileExist:Bool = NSFileManager.defaultManager().fileExistsAtPath(docPath)
        
        if(!fileExist) {
            NSFileManager.defaultManager().createDirectoryAtPath(docPath, withIntermediateDirectories: true, attributes: nil, error: nil)
        }
        
        KFUtil.skipBackupAttributeToItemAtPath(NSURL.fileURLWithPath(docPath)!)
        
        return docPath
    }
    
    func databasePath() -> String? {
        self.sqlPath()
//        let filePathString = SQLDOC + "/" + KF_EVENT_SQL
//        var dbPath: String = KFUtil.documentFilePath(filePathString)
        var dbGroupPath =  NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(KF_GROUP_ID)
      
        dbGroupPath = dbGroupPath!.URLByAppendingPathComponent(KF_EVENT_SQL)
        
        return dbGroupPath?.path
    }
}


