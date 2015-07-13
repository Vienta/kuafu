//
//  KFEventManager.swift
//  kuafu
//
//  Created by Vienta on 15/7/11.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import EventKit

private let sharedInstance = KFEventManager()

class KFEventManager: NSObject {
    
    // MARK: - Property
    var eventStore: EKEventStore?
    var selectedCalendarIdentifier: String?
    var selectedEventIdentifier: String?
    var eventsAccessGranted: Bool?
    var customCalendarIdentifiers: NSMutableArray?
   
    // MARK: - Singleton
    class var sharedManager: KFEventManager {
        return sharedInstance
    }
    
    // MARK: - init
    override init() {
        super.init()
    
        self.eventStore = EKEventStore()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.valueForKey(KF_EVENTKIT_ACCEES_GRANTED) != nil) {
            self.eventsAccessGranted = userDefaults.valueForKey(KF_EVENTKIT_ACCEES_GRANTED)?.boolValue
        } else {
            self.eventsAccessGranted = false
        }
        
        if (userDefaults.objectForKey(KF_EVENTKIT_SELECTED_CALENDAR) != nil) {
            self.selectedCalendarIdentifier = userDefaults.objectForKey(KF_EVENTKIT_SELECTED_CALENDAR) as? String
        } else {
            self.selectedCalendarIdentifier = ""
        }
        
        if (userDefaults.objectForKey(KF_EVENTKIT_CAL_IDENTIFIERS) != nil) {
            self.customCalendarIdentifiers = userDefaults.objectForKey(KF_EVENTKIT_CAL_IDENTIFIERS) as? NSMutableArray
        } else {
            self.customCalendarIdentifiers = NSMutableArray()
        }
    }
    
    // MARK: - Public Method
    func getLocalEventCalendars() -> NSArray {
        var allCalendars: NSArray! = self.eventStore?.calendarsForEntityType(EKEntityTypeEvent)
        var localCalendars: NSMutableArray = NSMutableArray()
        
        allCalendars.enumerateObjectsUsingBlock { (cal, idx, stop) -> Void in
            let calendar: EKCalendar = cal as! EKCalendar
            
            if (calendar.type.value == EKCalendarTypeLocal.value) {
                localCalendars.addObject(calendar)
            }
        }
        
        return localCalendars
    }
    
    func saveCustomCalendarIdentifier(identifier: String) -> Void {
        self.customCalendarIdentifiers?.addObject(identifier)
        NSUserDefaults.standardUserDefaults().setObject(self.customCalendarIdentifiers, forKey: KF_EVENTKIT_CAL_IDENTIFIERS)
    }
    
    func checkIfCalendarIsCustomWithIdentifier(identifier: String) -> Bool {
        var isCustomCalendar: Bool = false
        var customCal: NSArray = self.customCalendarIdentifiers!
        for (idx, value) in enumerate(customCal) {
            if (value as! String == identifier) {
                isCustomCalendar = true
                break
            }
        }
        return isCustomCalendar
    }
    
    func removeCalendarIdentifier(identifier: String) -> Void {
        self.customCalendarIdentifiers?.removeObject(identifier)
        NSUserDefaults.standardUserDefaults().setObject(self.customCalendarIdentifiers, forKey: KF_EVENTKIT_CAL_IDENTIFIERS)
    }
    
    func getEvetnsOfSelectCalendar() -> NSArray {
        var calendar: EKCalendar!
    
        if (self.selectedCalendarIdentifier?.isEmpty == false) {
            calendar = self.eventStore?.calendarWithIdentifier(self.selectedCalendarIdentifier)
        }
        
        var calendarArray: NSArray!
        if (calendar != nil) {
            calendarArray = [calendar]
        }
        
        var yearSeconds: NSTimeInterval = 365 * (60 * 60 * 24)
        var startDate: NSDate = NSDate(timeIntervalSinceNow: -yearSeconds)
        var endDate: NSDate = NSDate(timeIntervalSinceNow: yearSeconds)
        
        //TODO:这里需要修改
        let predicate = self.eventStore?.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)

        
        let eventsArray = self.eventStore?.eventsMatchingPredicate(predicate) as NSArray!
//        var uniqueEventsArray: NSMutableArray = NSMutableArray()
//        for (idx, event) in enumerate(eventsArray) {
//            let currentEvent: EKEvent = event as! EKEvent
//            
//            var eventExists: Bool = false
//
//            if (currentEvent.recurrenceRules.isEmpty == false) {
//                
//                for (jIdx, eventIdf) in enumerate(uniqueEventsArray) {
//                    let uniqueEvent = eventIdf as! EKEvent
//                    if (uniqueEvent.eventIdentifier == currentEvent.eventIdentifier) {
//                        eventExists = true
//                        break;
//                    }
//                }
//            }
//            
//            if eventExists == false {
//                uniqueEventsArray.addObject(currentEvent)
//            }
//        }
        //TODO:有问题 这里
//        uniqueEventsArray = [uniqueEventsArray.sortedArrayUsingSelector("compareStartDateWithEvent:")]
//        
//        return uniqueEventsArray
        
        return eventsArray
    }
    
    func deleteEventWithIdentifier(identifier: String) -> Void {
        var event: EKEvent = (self.eventStore?.eventWithIdentifier(identifier))!
        self.eventStore?.removeEvent(event, span: EKSpanFutureEvents, error: nil)
    }
    
    func requestAccessToEvents() -> Void {
        self.eventStore?.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted, error) -> Void in
            if (error == nil) {
                let accessGranted = granted as Bool
                self.eventsAccessGranted = accessGranted
            } else {
                println("\(error.localizedDescription)")
            }
        })
    }
    
    func loadEvents() -> NSArray {
        return self.getEvetnsOfSelectCalendar()
    }
}
