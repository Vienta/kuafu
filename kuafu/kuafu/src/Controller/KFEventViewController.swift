//
//  ViewController.swift
//  kuafu
//
//  Created by Vienta on 15/6/4.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import ObjectiveC
import MGSwipeTableCell


class KFEventViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate{

    // MARK: -- Property --
    @IBOutlet weak var tbvEvents: UITableView!
    @IBOutlet weak var lblEmpty: UILabel!
    
    var events: NSMutableArray!
    
    // MARK: -- IBActions --
    
    // MARK: -- Life Cycle --
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "KF_EVENT_CONTROLLER_TITLE".localized
        self.tbvEvents.rowHeight = UITableViewAutomaticDimension
        self.tbvEvents.estimatedRowHeight = 78.0
        self.tbvEvents.registerNib(UINib(nibName: "KFEventCell", bundle: nil), forCellReuseIdentifier: "KFEventCell")
        var addButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "btnTapped:")
        self.navigationItem.rightBarButtonItem = addButtonItem
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTask", name: KF_NOTIFICATION_UPDATE_TASK, object: nil)
        self.events = NSMutableArray(capacity: 0)

        self.showTaskData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- Private Methods --
    func showTaskData() -> Void {
        self.updateTask()
    }
    
    func updateTask() -> Void {
        
        self.events.removeAllObjects()
        var allEvents: NSMutableArray = NSMutableArray(array: KFEventDAO.sharedManager.getAllEvents())
        
        if allEvents.count == 0 {
            self.lblEmpty.hidden = false
            self.tbvEvents.hidden = true
            return
        } else {
            self.lblEmpty.hidden = true
            self.tbvEvents.hidden = false
        }

        //逾期任务
        var overDueEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        //普通任务 既无提醒时间，也无逾期时间
        var normalEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        //今日任务 提醒时间或者逾期时间是今天
        var todayEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        var currentDateStamp: NSTimeInterval = NSDate().timeIntervalSince1970
        
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
                
                if isToday == true {
                    todayEvents.addObject(subEvent)
                }
            }
        }
        
        allEvents.removeObjectsInArray(overDueEvents as [AnyObject])
        allEvents.removeObjectsInArray(todayEvents as [AnyObject])
        
        if overDueEvents.count > 0 {
            var overDueEventDict: NSDictionary = ["title": "KF_OVERDUE_TASK".localized,"events": overDueEvents]
            self.events.addObject(overDueEventDict)
        }
        
        if todayEvents.count > 0 {
            var todayEventDict: NSDictionary = ["title": "KF_TODAY_TASK".localized,"events": todayEvents]
            self.events.addObject(todayEventDict)
        }
        normalEvents = allEvents
        if normalEvents.count > 0 {
            var normalEventDict: NSDictionary = ["title": "KF_NORMAL_TASK".localized,"events": normalEvents]
            self.events.addObject(normalEventDict)
        }
        
        self.tbvEvents.reloadData()
    }
    // MARK: -- MGSwipeTableCellDelegate --
    func swipeTableCell(cell: MGSwipeTableCell!, tappedButtonAtIndex index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if direction == MGSwipeDirection.LeftToRight {
            if index == 0 {
                println("标记为完成")
            }
        }
        if direction == MGSwipeDirection.RightToLeft {
            if index == 0 {
                println("删除")
            }
            if index == 1 {
                println("编辑")
            }
        }
        
        return true
    }
    
    // MARK: -- UITableViewDelegate && UITableViewDataSource --
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var currentEventDict: NSDictionary = self.events.objectAtIndex(section) as! NSDictionary
        var currentEvents: NSArray = currentEventDict.objectForKey("events") as! NSArray
        return currentEvents.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var currentEventSectionTitle: String = self.events.objectAtIndex(section).objectForKey("title") as! String
        return currentEventSectionTitle
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.grayColor()
        header.textLabel.font = UIFont.systemFontOfSize(14)
        header.contentView.backgroundColor = KF_BG_COLOR
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var eventCell: KFEventCell = tableView.dequeueReusableCellWithIdentifier("KFEventCell") as! KFEventCell
        eventCell.leftButtons = [MGSwipeButton(title: "KF_ARCHIEVE".localized, backgroundColor: UIColor(red: 0.13, green: 0.41, blue: 1, alpha: 1)) { (cell: MGSwipeTableCell!) -> Bool in
            return true
        }]
        eventCell.rightButtons = [
            MGSwipeButton(title: " " + "KF_DELETE".localized + " ", backgroundColor: UIColor(red: 1, green: 0, blue: 0.13, alpha: 1)) { (cell: MGSwipeTableCell!) -> Bool in
                return true
            },
            MGSwipeButton(title: " " + "KF_EDIT".localized + " ", backgroundColor: UIColor(red: 0.8, green: 0.76, blue: 0.81, alpha: 1)) { (cell: MGSwipeTableCell!) -> Bool in
                return true
            }
        ]
        
        eventCell.leftExpansion.buttonIndex = 0
        eventCell.rightExpansion.buttonIndex = 0
        eventCell.delegate = self
        
        var eventDict: NSDictionary = self.events[indexPath.section] as! NSDictionary
        var eventInSection: NSArray = eventDict.objectForKey("events") as! NSArray
        var eventDO: KFEventDO = eventInSection[indexPath.row] as! KFEventDO
        
        eventCell.configData(eventDO)
        
        return eventCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

