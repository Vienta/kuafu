//
//  KFCalendarViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/9.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import JTCalendar
import MKEventKit

class KFCalendarViewController: UIViewController, ZoomTransitionProtocol, JTCalendarDataSource {
    // MARK: - Property
    @IBOutlet weak var igvCalendar: UIImageView!
    @IBOutlet weak var calendarContentVIew: JTCalendarContentView!
    @IBOutlet weak var tbvCalendar: UITableView!
    var calendar: JTCalendar!

    // MARK: - IBActions
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar = JTCalendar()
        
        // Do any additional setup after loading the view.
        self.tbvCalendar.tableHeaderView = self.calendarContentVIew
        self.tbvCalendar.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.setupCalendar()
        self.calendarEvents()
    }
    
    override func viewDidLayoutSubviews() {
        self.calendar.repositionViews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    func setupCalendar() -> Void {
        self.calendar.calendarAppearance.calendar().firstWeekday = 2
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = true
        self.calendar.calendarAppearance.dayCircleColorToday = KF_THEME_COLOR
        self.calendar.calendarAppearance.dayTextFont = UIFont.systemFontOfSize(14)
        self.calendar.calendarAppearance.weekDayTextFont = UIFont.systemFontOfSize(14)
        self.calendar.calendarAppearance.weekDayTextColor = KF_ICON_BG_COLOR
        self.calendar.contentView = self.calendarContentVIew
        self.calendar.dataSource = self as JTCalendarDataSource
        self.calendar.reloadData()
        self.calendarCurrentDate()
    }
    
    func calendarEvents() -> Void {
        let eventStore = EKEventStore()
//        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
//        case .Authorized:
//            println("Authorized")
//            self.eventsFromLastYearAndFutureYear()
//        case .Denied:
//            println("Access Denied")
//        case .NotDetermined:
//            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error: NSError!) -> Void in
//                if granted {
//                
//                } else {
//                    println("Access Denied")
//                }
//            })
//        default:
//            println("Case Default")
//        }

        if EKEventStore.mk_isAccessAuthorized() == false {
            println("Access Denied")
        } else {
            EKEventStore.mk_registerEventStore(eventStore)
            self.eventsFromLastYearAndFutureYear()
        }
    }
    
    
    func eventsFromLastYearAndFutureYear() -> NSArray! {
        var yearSeconds: NSTimeInterval = 365 * (60 * 60 * 24)
        var startDate: NSDate = NSDate(timeIntervalSinceNow: -yearSeconds)
        var endDate: NSDate = NSDate(timeIntervalSinceNow: yearSeconds)
        
        var eventsInThoseTwoYears = EKEvent.mk_eventsFrom(startDate, to: endDate)
        println("eventsInThoseTwoYears:\(eventsInThoseTwoYears)")
    
//        var event: EKEvent = EKEvent()
//        event.eventIdentifier
        
        if eventsInThoseTwoYears != nil {
            let events = eventsInThoseTwoYears as NSArray
            var firstEvents: EKEvent = events.firstObject as! EKEvent
            println("firstEvents:\(firstEvents) eventIdentifier:\(firstEvents.eventIdentifier)")
        }
        
        
        return eventsInThoseTwoYears
    }
    
    // MARK: - Public Methods
    
    
    
    // MARK: - ZoomTransitionProtocol
    func viewForTransition() -> UIView {
        println("\(__FUNCTION__)")
        return self.igvCalendar
    }
    
    // MARK: - JTCalendarDataSource
    func calendarHaveEvent(calendar: JTCalendar!, date: NSDate!) -> Bool {
        return false
    }
    
    func calendarDidDateSelected(calendar: JTCalendar!, date: NSDate!) {

    }
    
    func calendarDidLoadNextPage() {
        self.calendarCurrentDate()
    }
    
    func calendarDidLoadPreviousPage() {
        self.calendarCurrentDate()
    }
    
    func calendarCurrentDate() -> Void {
        var newCalendar: NSCalendar = self.calendar.calendarAppearance.calendar()
        
        var comps: NSDateComponents = newCalendar.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth, fromDate: self.calendar.currentDate)
        var currentMonthIdx = comps.month
        
        var dateFormatter: NSDateFormatter!
        if (dateFormatter == nil) {
            dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = self.calendar.calendarAppearance.calendar().timeZone
        }
        
        while (currentMonthIdx <= 0) {
            currentMonthIdx += 12
        }
        
        var monthSymbols: NSArray = dateFormatter.standaloneMonthSymbols as NSArray
        var monthText: String = monthSymbols.objectAtIndex(currentMonthIdx - 1).capitalizedString

        self.title = "\(comps.year)\(monthText)"
    }
}
