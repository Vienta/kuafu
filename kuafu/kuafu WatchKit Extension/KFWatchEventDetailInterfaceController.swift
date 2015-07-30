//
//  KFWatchEventDetailInterfaceController.swift
//  kuafu
//
//  Created by Vienta on 15/7/28.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import WatchKit
import Foundation


class KFWatchEventDetailInterfaceController: WKInterfaceController {

    @IBOutlet weak var lblTask: WKInterfaceLabel!
    @IBOutlet weak var btnDelete: WKInterfaceButton!
    @IBOutlet weak var btnComplete: WKInterfaceButton!
    @IBOutlet weak var lblDate: WKInterfaceLabel!
    var currentEvent: KFEventDO!
    // MARK: - Life Cycle
    
    @IBAction func btnDeleteTask() {
        self.currentEvent.status = NSNumber(integerLiteral: KEventStatus.Delete.rawValue)
        KFEventDAO.sharedManager.saveEvent(self.currentEvent)
        WKInterfaceController.openParentApplication(["updatetask": true], reply: { (result, error) -> Void in
            
        })
        self.popController()
    }
    
    @IBAction func btnCompleteTask() {
        self.currentEvent.status = NSNumber(integerLiteral: KEventStatus.Achieve.rawValue)
        KFEventDAO.sharedManager.saveEvent(self.currentEvent)
        WKInterfaceController.openParentApplication(["updatetask": true], reply: { (result, error) -> Void in
            
        })
        self.popController()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        var eventDO:KFEventDO = context as! KFEventDO
        self.currentEvent = eventDO
        self.lblTask.setText(eventDO.content)
        self.dueDate(eventDO)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - Private Method
    func dueDate(event: KFEventDO) {
        if (event.endtime != 0) {
            var tmpDate: NSDate = KFUtil.dateFromTimeStamp(event.endtime.doubleValue) as NSDate
            let tmpDateString = "KF_TIME_DUETO".localized + ":" + KFUtil.getDate(tmpDate)
            self.lblDate.setText(tmpDateString)
            return;
        }
        if (event.starttime != 0) {
            var tmpDate: NSDate = KFUtil.dateFromTimeStamp(event.starttime.doubleValue) as NSDate
            let tmpDateString = "KF_TIME_ALERT".localized + ":" + KFUtil.getDate(tmpDate)
            self.lblDate.setText(tmpDateString)
            return;
        }
        self.lblDate.setText("")
    }
}
