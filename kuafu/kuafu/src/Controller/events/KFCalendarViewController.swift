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
import DAAlertController

class KFCalendarViewController: UIViewController, ZoomTransitionProtocol, JTCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Property
    @IBOutlet weak var igvCalendar: UIImageView!
    @IBOutlet weak var calendarContentVIew: JTCalendarContentView!
    @IBOutlet weak var tbvCalendar: UITableView!

    var calendar: JTCalendar!
    var eventsByDate: NSMutableDictionary!
    var currentDayEvents: NSMutableArray!
    var selectDate: NSDate!

    // MARK: - IBActions
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendar = JTCalendar()
        self.eventsByDate = NSMutableDictionary()
        self.currentDayEvents = NSMutableArray()
        self.selectDate = NSDate()
        // Do any additional setup after loading the view.
        self.tbvCalendar.tableHeaderView = self.calendarContentVIew
        self.tbvCalendar.contentInset = UIEdgeInsetsMake(64, 0, 49, 0)
        self.tbvCalendar.registerNib(UINib(nibName: "KFCalendarCell", bundle: nil), forCellReuseIdentifier: "KFCalendarCell")
        
        self.setupCalendar()
        self.calendarEvents()
        
        self.calendarDidDateSelected(self.calendar, date: NSDate())
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
        self.calendar.calendarAppearance.dayTextFont = UIFont(name: "Helvetica Neue", size: 16)
        self.calendar.calendarAppearance.weekDayTextFont = UIFont.systemFontOfSize(14)
        self.calendar.calendarAppearance.weekDayTextColor = KF_ICON_BG_COLOR
        self.calendar.calendarAppearance.dayDotColor = KF_THEME_COLOR
        self.calendar.contentView = self.calendarContentVIew
        self.calendar.dataSource = self as JTCalendarDataSource
        self.calendar.reloadData()
        self.calendarCurrentDate()
    }
    
    func calendarEvents() -> Void {
        let eventStore = EKEventStore()

        if EKEventStore.mk_isAccessAuthorized() == false {
            print("Access Denied")
            self.alertEventAccessibility()
        } else {
            EKEventStore.mk_registerEventStore(eventStore)
            self.eventsFromLastYearAndFutureYear()
            self.calendar.reloadData()
        }
    }
    
    func eventsFromLastYearAndFutureYear() -> NSArray! {
        let yearSeconds: NSTimeInterval = 365 * (60 * 60 * 24)
        let startDate: NSDate = NSDate(timeIntervalSinceNow: -yearSeconds)
        let endDate: NSDate = NSDate(timeIntervalSinceNow: yearSeconds)
        
        let eventsInThoseTwoYears = EKEvent.mk_eventsFrom(startDate, to: endDate)
        
        if eventsInThoseTwoYears != nil {
            let events = eventsInThoseTwoYears as NSArray
            
            for (idx, evt) in events.enumerate() {
                let subEvent = evt as! EKEvent
                let key: String = KFUtil.getShortDate(subEvent.startDate) as String
                
                if (self.eventsByDate[key] == nil) {
                    self.eventsByDate[key] = NSMutableArray()
                }
                
                (self.eventsByDate[key] as! NSMutableArray).addObject(subEvent)
            }
        }
        
        return eventsInThoseTwoYears
    }
    
    func alertEventAccessibility() -> Void {
        let randomNum = Int(arc4random_uniform(3));
        if (randomNum % 3 == 0) {//减少弹出频率
            let cancelAction: DAAlertAction = DAAlertAction(title: "KF_LOCALNOTIFICATION_GET_IT".localized, style: DAAlertActionStyle.Destructive, handler: nil)
            DAAlertController.showAlertViewInViewController(self, withTitle: "KF_ALERT_TIPS".localized, message: "KF_EVENT_ACCESSIBILITY_TIPS".localized, actions: [cancelAction])
        }
    }
    
    // MARK: - Public Methods
    
    
    // MARK: - ZoomTransitionProtocol
    func viewForTransition() -> UIView {
        print("\(#function)")
        return self.igvCalendar
    }
    
    // MARK: - JTCalendarDataSource
    func calendarHaveEvent(calendar: JTCalendar!, date: NSDate!) -> Bool {
        
        let key: String = KFUtil.getShortDate(date) as String
        let events: NSArray! = self.eventsByDate[key] as? NSArray
        if (events != nil && events.count > 0) {
            return true
        }
        
        return false
    }
    
    func calendarDidDateSelected(calendar: JTCalendar!, date: NSDate!) {
        let key: String = KFUtil.getShortDate(date)
        let selectDateEvents: NSArray! = self.eventsByDate[key] as? NSArray
        self.selectDate = date
        self.currentDayEvents.removeAllObjects()
        if (selectDateEvents != nil && selectDateEvents.count > 0) {
            self.currentDayEvents.addObjectsFromArray(selectDateEvents as [AnyObject])
        }
        self.tbvCalendar.reloadData()
    }
    
    func calendarDidLoadNextPage() {
        self.calendarCurrentDate()
    }
    
    func calendarDidLoadPreviousPage() {
        self.calendarCurrentDate()
    }
    
    func calendarCurrentDate() -> Void {
        let newCalendar: NSCalendar = self.calendar.calendarAppearance.calendar()
        
        let comps: NSDateComponents = newCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: self.calendar.currentDate)
        var currentMonthIdx = comps.month
        
        var dateFormatter: NSDateFormatter!
        if (dateFormatter == nil) {
            dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = self.calendar.calendarAppearance.calendar().timeZone
        }
        
        while (currentMonthIdx <= 0) {
            currentMonthIdx += 12
        }
        
        let monthSymbols: NSArray = dateFormatter.standaloneMonthSymbols as NSArray
        let monthText: String = monthSymbols.objectAtIndex(currentMonthIdx - 1).capitalizedString

        self.title = "\(comps.year)\(monthText)"
    }
    
    // MARK: - UITableViewDelegate && UITableViewDataSource 
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentDayEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let calendarCell: KFCalendarCell = tableView.dequeueReusableCellWithIdentifier("KFCalendarCell") as! KFCalendarCell
        let calendarEvent: EKEvent = self.currentDayEvents.objectAtIndex(indexPath.row) as! EKEvent
        calendarCell.configureWithEvent(calendarEvent, targetDate: self.selectDate)
        return calendarCell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 1))
        headerView.backgroundColor = KF_LINE_COLOR
        return headerView
    }
}
