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


class KFEventViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    // MARK: -- property --
    @IBOutlet weak var tbvEvents: UITableView!
    var events: NSMutableArray!
    
    // MARK: -- IBActions --
    @IBAction func btnTapped(sender: AnyObject) {
        var eventWriteViewController: KFEventWriteViewController = KFEventWriteViewController(nibName: "KFEventWriteViewController", bundle: nil)
        var eventWriteNavigationController: UINavigationController = UINavigationController(rootViewController: eventWriteViewController)
        self.navigationController?.presentViewController(eventWriteNavigationController, animated: true, completion: nil)
    }
    
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

        var allEvents: NSArray = KFEventDAO.sharedManager.getAllEvents()
        self.events = NSMutableArray(array: allEvents)
        
        //逾期任务
        var overDueEvents: NSMutableArray = NSMutableArray(capacity: 0)
        var normalEvents: NSMutableArray = NSMutableArray(capacity: 0)
        
        var currentDateStamp: NSTimeInterval = NSDate().timeIntervalSince1970

        allEvents.enumerateObjectsUsingBlock { (element, index, stop) -> Void in
            let subEvent = element as! KFEventDO
            if subEvent.endtime != nil {
                if currentDateStamp > subEvent.endtime.doubleValue {
                    overDueEvents.addObject(subEvent)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: -- Private Methods --

    // MARK: -- UITableViewDelegate && UITableViewDataSource --
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
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
        var eventDO: KFEventDO = self.events[indexPath.row] as! KFEventDO
        eventCell.configData(eventDO)
        return eventCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

