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

    let dayInterval = [
        "00:00:00","00:30:00","01:00:00","01:30:00","02:00:00","02:30:00","03:00:00","03:30:00","04:00:00","04:30:00","05:00:00","05:30:00",
        "06:00:00","06:30:00","07:00:00","07:30:00","08:00:00","08:30:00","09:00:00","09:30:00","10:00:00","10:30:00","11:00:00","11:30:00",
        "12:00:00","12:30:00","13:00:00","13:30:00","14:00:00","14:30:00","15:00:00","15:30:00","16:00:00","16:30:00","17:00:00","17:30:00",
        "18:00:00","18:30:00","19:00:00","19:30:00","20:00:00","20:30:00","21:00:00","21:30:00","22:00:00","22:30:00","23:00:00","23:30:00"]

    
    @IBOutlet weak var tbvEvent: WKInterfaceTable!
    @IBOutlet weak var lblTips: WKInterfaceLabel!
    
    var watchEvents: NSMutableArray!
    var watchData: NSMutableArray!
    
    // MARK: - IBActions

    @IBAction func menuTapped() {
        let HH = KFUtil.getTodayShortDate(NSDate()).componentsSeparatedByString(":")[0]
        let MM = KFUtil.getTodayShortDate(NSDate()).componentsSeparatedByString(":")[1]
        
        var targetIdx: Int!
        for (idx, timeInterval) in enumerate(self.dayInterval) {
            var targetHH: String = timeInterval.componentsSeparatedByString(":")[0]
            if (targetHH == HH) {
                var targetMM: String = timeInterval.componentsSeparatedByString(":")[1]
                if (MM.toInt() > targetMM.toInt()) {
                    targetIdx = idx + 1
                }
            }
        }
        if (targetIdx >= self.dayInterval.count) {
            //日常任务输入
            self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain) { (input) -> Void in
                println("INPUT:\(input)")
                if (input == nil) {
                    self.popToRootController()
                } else {
                    if (input.isEmpty == false) {
                        let inputText = input[0] as! String
                        self.createEventWithContent(inputText)
                    } else {
                        self.popToRootController()
                    }
                }
            }
        } else {
            //进入时间选择页面
            var intervalSlice: Array<String> = Array(self.dayInterval[targetIdx..<self.dayInterval.count])
            self.pushControllerWithName("dayInterval", context: intervalSlice)
        }
    }
    
    // MARK: - Private Methods
    func createEventWithContent(content:String) ->Void {
        var eventDO: KFEventDO = KFEventDO()
        eventDO.content = content
        if (eventDO.status == nil) {
            eventDO.status = NSNumber(integerLiteral: KEventStatus.Normal.rawValue)
        }
        
        let eventId = KFEventDAO.sharedManager.saveEvent(eventDO) as NSNumber
        
        let newTaskUserInfo = [KF_WK_OPEN_PARENT_APPLICATION_NEW_TASK: eventId]
        WKInterfaceController.openParentApplication(newTaskUserInfo, reply: { (result, error) -> Void in
            
        })
    }
    
//    func startUserActivity() {
//        let activity = NSUserActivity(activityType: KF_HANDOFF_ACTIVITY_TYPE)
//        activity.title = "watch handoff"
//        activity.userInfo = [KF_HANDOFF_ACTIVITY_KEY:"test"]
//    }
    
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
        
        if (allEvents.count == 0) {
            self.lblTips.setHidden(false)
            self.tbvEvent.setHidden(true)
        } else {
            self.lblTips.setHidden(true)
            self.tbvEvent.setHidden(false)
        }
        
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
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        NSFileCoordinator.addFilePresenter(self)
        updateUserActivity(KF_HANDOFF_ACTIVITY_TYPE, userInfo: [KF_HANDOFF_ACTIVITY_KEY:"test"], webpageURL: nil)
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
