//
//  KFEventDAO.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import FMDB

private let sharedInstance = KFEventDAO()



class KFEventDAO: KFBaseDAO {
    
    class var sharedManager: KFEventDAO {
        return sharedInstance
    }
    
    override init() {
        super.init()
    }
    
    override func tableName() -> String {
        return "KFEvent"
    }
    
    override func createSqlString() -> String {
        let sqlStr: String = "CREATE TABLE IF NOT EXISTS " + self.tableName()
            + "(eventid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            + "title TEXT,"
            + "content TEXT,"
            + "status INTEGER,"
            + "starttime INTEGER,"
            + "endtime INTEGER,"
            + "updatetime INTEGER,"
            + "creattime INTEGER,"
            + "longitude INTEGER,"
            + "latitude INTEGER,"
            + "userid INTEGER DEFAULT 0)"
        
        return sqlStr
    }
    
    func eventFromResultSet(result: FMResultSet) -> KFEventDO {
        let eventDO: KFEventDO = KFEventDO()
        eventDO.eventid = NSNumber(int: result.intForColumn("eventid"))
        eventDO.title = result.stringForColumn("title")
        eventDO.content = result.stringForColumn("content")
        eventDO.status = NSNumber(int: result.intForColumn("status"))
        eventDO.starttime = NSNumber(double: result.doubleForColumn("starttime"))
        eventDO.endtime = NSNumber(double: result.doubleForColumn("endtime"))
        eventDO.updatetime = NSNumber(double: result.doubleForColumn("updatetime"))
        eventDO.creattime =  NSNumber(double: result.doubleForColumn("creattime"))
        eventDO.longitude = NSNumber(double: result.doubleForColumn("longitude"))
        eventDO.latitude = NSNumber(double: result.doubleForColumn("latitude"))
        
        return eventDO
    }
    
    func insertEvent(event: KFEventDO,db: FMDatabase) -> Bool {
        let sql: String =   "INSERT INTO " + self.tableName()
                            + "(eventid,title,content,status,starttime,endtime,updatetime,creattime,longitude,latitude) "
                            + "VALUES(?,?,?,?,?,?,?,?,?,?)"
        
        let creattime: Double = KFUtil.getCurrentTime()
        let updatetime: Double = KFUtil.getCurrentTime()
        event.creattime = NSNumber(double: creattime)
        event.updatetime = NSNumber(double: updatetime)
        
        var result: Bool!
        let sqlArr: Array = [SAFE_OBJC(event.eventid), SAFE_OBJC(event.title),
                            SAFE_OBJC(event.content), SAFE_OBJC(event.status),
                            SAFE_OBJC(event.starttime), SAFE_OBJC(event.endtime),
                            SAFE_OBJC(event.updatetime), SAFE_OBJC(event.creattime),
                            SAFE_OBJC(event.longitude), SAFE_OBJC(event.latitude)]
    
        result = db.executeUpdate(sql, withArgumentsInArray: sqlArr)

        if result == false {
            NSLog("insert event err:%@", db.lastErrorMessage())
        }
        return result
    }
    
    
    func updateEvent(event: KFEventDO) -> Bool {
        
        var result: Bool!
        
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            let query: String = "UPDATE " + self.tableName() + " SET"
            let keyValues: NSMutableString = NSMutableString()
            let arguments: NSMutableArray = NSMutableArray()
            
            keyValues.appendString(" updatetime=?,")
            arguments.addObject(KFUtil.getCurrentTime())
            
            if (event.title != nil) {
                keyValues.appendString(" title=?,")
                arguments.addObject(event.title)
            }
            if (event.content != nil) {
                keyValues.appendString(" content=?,")
                arguments.addObject(event.content)
            }
            if (event.status != nil) {
                keyValues.appendString(" status=?,")
                arguments.addObject(event.status)
            }
            if (event.starttime != nil) {
                keyValues.appendString(" starttime=?,")
                arguments.addObject(event.starttime)
            }
            if (event.endtime != nil) {
                keyValues.appendString(" endtime=?,")
                arguments.addObject(event.endtime)
            }
            if (event.longitude != nil) {
                keyValues.appendString(" longitude=?,")
                arguments.addObject(event.longitude)
            }
            if (event.latitude != nil) {
                keyValues.appendString(" latitude=?,")
                arguments.addObject(event.latitude)
            }
            
            
            let keyString: String = keyValues.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
            
            let lastQuery: String = query + keyString + "WHERE eventid=?"
            arguments.addObject(event.eventid)
            
            result = db.executeUpdate(lastQuery, withArgumentsInArray: arguments as [AnyObject])
            
            if result == false {
                NSLog("update error:%@", db.lastErrorMessage())
            }

        })
        
        return result
    }
    
    
    func getEventById(eventid: NSNumber?) -> KFEventDO? {

        print(eventid)
        if (eventid == nil) {
            return nil
        }
        
        let sqlEventId: NSNumber = eventid!
        
        let sql: String = "SELECT * FROM " + self.tableName() + " WHERE eventId = ?"
        
        var eventDO: KFEventDO!
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            let result:FMResultSet = db.executeQuery(sql, withArgumentsInArray: [sqlEventId])
            if result.next() {
                eventDO = self.eventFromResultSet(result)
            }
            result.close()
        })
        
        return eventDO
    }
    
    
    func saveEvent(event: KFEventDO) -> NSNumber {
        let isExistEvent: KFEventDO? = self.getEventById(event.eventid)
        
        var successEventid: NSNumber!
        
        if ((isExistEvent) == nil) {
            dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
                let insertResult: Bool = self.insertEvent(event, db: db)
                if insertResult == true {
                    successEventid = NSNumber(longLong: db.lastInsertRowId())
                } else {
                    successEventid = NSNumber(longLong: 0)
                }
            })
        } else {
            self.updateEvent(event)
            successEventid = event.eventid
        }
        
        return successEventid
    }
    
    func getAllEvents() -> NSArray {
        let sql: String = "SELECT * FROM " + self.tableName()
        let result: NSMutableArray = NSMutableArray()
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            let resultSet: FMResultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            while(resultSet.next()) {
                let event: KFEventDO = self.eventFromResultSet(resultSet)
                result.addObject(event)
            }
        })
        return result
    }
    
    func getAllNoArchiveAndNoDeleteEvents() -> NSArray {
        let sql: String = "SELECT * FROM " + self.tableName() + " WHERE status != \(KEventStatus.Achieve.rawValue) AND status != \(KEventStatus.Delete.rawValue) ORDER BY updatetime DESC"
        let result: NSMutableArray = NSMutableArray()
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            let resultSet: FMResultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            while(resultSet.next()) {
                let event: KFEventDO = self.eventFromResultSet(resultSet)
                result.addObject(event)
            }
        })
        return result
    }
}
