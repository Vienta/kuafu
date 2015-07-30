//
//  InterfaceController.swift
//  kuafu WatchKit Extension
//
//  Created by Vienta on 15/7/23.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController,NSFilePresenter {

    @IBOutlet weak var tbvEvent: WKInterfaceTable!
    
    var watchEvents: NSMutableArray!
    var watchData: NSMutableArray!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        NSFileCoordinator.addFilePresenter(self)
    }
    
    // MARK: - NSFilePresenter
    var presentedItemURL: NSURL? {
        var dbGroupPath =  NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(KF_GROUP_ID)
        dbGroupPath = dbGroupPath!.URLByAppendingPathComponent(KF_EVENT_SQL)
        return dbGroupPath
    }
    
    var presentedItemOperationQueue: NSOperationQueue {
        
        return NSOperationQueue.mainQueue()
    }
    
    func presentedItemDidChange() {
        self.updateTasks()
    }
    
    // MARK: - Private Methods
    func updateTasks() {
        self.watchEvents = NSMutableArray(capacity: 0)
        self.watchData = NSMutableArray(capacity: 0)
        //逾期任务  以下为冗余代码
        var overDueEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        //普通任务 既无提醒时间，也无逾期时间
        var normalEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        //今日任务 提醒时间或者逾期时间是今天
        var todayEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        var currentDateStamp: NSTimeInterval = NSDate().timeIntervalSince1970
        
        var allEvents: NSMutableArray = NSMutableArray(array: KFEventDAO.sharedManager.getAllNoArchiveAndNoDeleteEvents())
        
        allEvents.enumerateObjectsUsingBlock { (element, index, stop) -> Void in
            
            let subEvent = element as! KFEventDO
            if subEvent.endtime.doubleValue > 0 {
                if currentDateStamp > subEvent.endtime.doubleValue {
                    overDueEvents.addObject(subEvent)
                }
            }
            
            if subEvent.starttime.doubleValue > 0 || subEvent.endtime.doubleValue > 0 {
                var isStartTimeToday: Bool = NSCalendar.currentCalendar().isDateInToday(KFUtil.dateFromTimeStamp(subEvent.starttime.doubleValue))
                var isEndTimeToday: Bool = NSCalendar.currentCalendar().isDateInToday(KFUtil.dateFromTimeStamp(subEvent.endtime.doubleValue))
                
                var isToday: Bool = (isStartTimeToday || isEndTimeToday)
                
                if isToday == true && (currentDateStamp < subEvent.endtime.doubleValue) {
                    todayEvents.addObject(subEvent)
                }
            }
        }
        
        allEvents.removeObjectsInArray(overDueEvents as [AnyObject])
        allEvents.removeObjectsInArray(todayEvents as [AnyObject])
        
        if overDueEvents.count > 0 {
            var overDueEventDict: NSDictionary = ["title": "KF_OVERDUE_TASK".localized,"events": overDueEvents]
            self.watchEvents.addObject("KF_OVERDUE_TASK".localized)
            self.watchData.addObject("KFWatchEvensTableHeaderController")
            for (idx, event) in enumerate(overDueEvents) {
                self.watchEvents.addObject(event)
                self.watchData.addObject("KFWatchEventsTableRowController")
            }
            
        }
        
        if todayEvents.count > 0 {
            var todayEventDict: NSDictionary = ["title": "KF_TODAY_TASK".localized,"events": todayEvents]
            self.watchEvents.addObject("KF_TODAY_TASK".localized)
            self.watchData.addObject("KFWatchEvensTableHeaderController")
            
            for (idx, event) in enumerate(todayEvents) {
                self.watchEvents.addObject(event)
                self.watchData.addObject("KFWatchEventsTableRowController")
            }
        }
        normalEvents = allEvents
        if normalEvents.count > 0 {
            var normalEventDict: NSDictionary = ["title": "KF_NORMAL_TASK".localized,"events": normalEvents]
            self.watchEvents.addObject("KF_NORMAL_TASK".localized)
            self.watchData.addObject("KFWatchEvensTableHeaderController")
            
            for (idx, event) in enumerate(normalEvents) {
                self.watchEvents.addObject(event)
                self.watchData.addObject("KFWatchEventsTableRowController")
            }
        }
        
        self.tbvEvent.setRowTypes(self.watchData as Array)
        
        for (idx, name) in enumerate(self.watchData) {
            if (name as! String == "KFWatchEventsTableRowController" ) {
                let row = self.tbvEvent.rowControllerAtIndex(idx) as! KFWatchEventsTableRowController
                let event = self.watchEvents.objectAtIndex(idx) as! KFEventDO
                row.lblEventContent.setText(event.content as String)
            } else {
                let header = self.tbvEvent.rowControllerAtIndex(idx) as! KFWatchEvensTableHeaderController
                let headerTitle = self.watchEvents.objectAtIndex(idx) as! String
                header.lblHeader.setText(headerTitle)
            }
        }
    }
    
    // MARK: - Life Cycle
    override func willActivate() {

        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.updateTasks()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let segueEvent = self.watchEvents.objectAtIndex(rowIndex) as! KFEventDO
        return segueEvent
    }
}
