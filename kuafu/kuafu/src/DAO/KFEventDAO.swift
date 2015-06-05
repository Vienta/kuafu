//
//  KFEventDAO.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

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
        var eventDO: KFEventDO = KFEventDO()
        eventDO.eventid = NSNumber(int: result.intForColumn("eventid"))
        eventDO.title = result.stringForColumn("title")
        eventDO.content = result.stringForColumn("content")
        eventDO.starttime = NSNumber(double: result.doubleForColumn("starttime"))
        eventDO.endtime = NSNumber(double: result.doubleForColumn("endtime"))
        eventDO.updatetime = NSNumber(double: result.doubleForColumn("updatetime"))
        eventDO.creattime =  NSNumber(double: result.doubleForColumn("creattime"))
        eventDO.longitude = NSNumber(double: result.doubleForColumn("longitud"))
        eventDO.latitude = NSNumber(double: result.doubleForColumn("latitude"))
        
        return eventDO
    }
    
    func insertEvent(event: KFEventDO,db: FMDatabase) -> Bool {
        var sql: String =   "INSERT INTO " + self.tableName()
                            + "(eventid,title,content,starttime,endtime,updatetime,creattime,longitude,latitude) "
                            + "VALUES(?,?,?,?,?,?,?,?,?)"
        
        var creattime: Double = KFUtil.getCurrentTime()
        var updatetime: Double = KFUtil.getCurrentTime()
        
        var result: Bool!
    
        result = db.executeUpdate(sql, withArgumentsInArray: [event.eventid, event.title, event.content, event.starttime, event.endtime, event.updatetime, event.creattime, event.longitude, event.latitude])
        
        if !(result) {
            NSLog("insert event err:%@", db.lastErrorMessage())
        }
        return result
    }
    
    
    func updateEvent(event: KFEventDO) -> Bool {
        
        var result: Bool!
        
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            var query: String = "UPDATE " + self.tableName() + " SET"
            var keyValues: NSMutableString = NSMutableString()
            var arguments: NSMutableArray = NSMutableArray()
            
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
            
            
            var keyString: String = keyValues.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ","))
            
            var lastQuery: String = query + keyString + "WHERE eventid=?"
            arguments.addObject(event.eventid)
            
            result = db.executeUpdate(lastQuery, withArgumentsInArray: arguments as [AnyObject])
            
            if result == false {
                NSLog("update error:%@", db.lastErrorMessage())
            }

        })
        
        return result
    }
    
    
    func getEventById(eventid: NSNumber) -> KFEventDO {
        var sql: String = "SELECT * FROM " + self.tableName() + " WHERE eventId = ?"
        
        var eventDO: KFEventDO!
        dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
            var result:FMResultSet = db.executeQuery(sql, withArgumentsInArray: [eventid])
            if result.next() {
                eventDO = self.eventFromResultSet(result)
            }
            result.close()
        })
        
        return eventDO
    }
    
    
    func saveEvent(event: KFEventDO) -> Bool {

        var isExistEvent: KFEventDO? = self.getEventById(event.eventid)
        
        if ((isExistEvent) == nil) {
            dbQueue?.inDatabase({ (db:FMDatabase!) -> Void in
                self.insertEvent(event, db: db)
            })
        } else {
            self.updateEvent(event)
        }
        
        return true
    }
}
