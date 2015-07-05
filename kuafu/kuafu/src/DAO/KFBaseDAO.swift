//
//  KFBaseDAO.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import FMDB

class KFBaseDAO: NSObject {
    var dbQueue: FMDatabaseQueue?
    
    override init() {
        super.init()
        self.creatFMDatabase()
        self.creatTable()
    }
     
    func creatFMDatabase() -> Bool {
        if(((dbQueue)) == nil) {
            dbQueue = KFDBManager.sharedManager.dbQueue
        }
        return true
    }
    
    func creatTable() -> Bool {
        
        var res: Bool!
        
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            var result: Bool = db.executeUpdate(self.createSqlString(), withArgumentsInArray: nil)
            if ((result)) {
                println("creat or open table \(self.tableName()) success")
            } else {
                println("create or open table \(self.tableName()) failure, error:\(db.lastErrorMessage())")
            }
            res = result
        })
        
        return res
    }
    
    func createSqlString() -> String {
        return "creatSqlString"
    }
    
    func tableName() -> String {
        return "tableName"
    }
    
    func dropTableWithName(tableName: String) -> Bool {
        var sql: String = "drop table if exists" + tableName + ";"
        var res: Bool!
        
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            res = db.executeUpdate(sql, withArgumentsInArray: nil);
        })
        return res
    }
}
