//
//  KFWatchTimeSelectorInterfaceController.swift
//  kuafu
//
//  Created by Vienta on 15/7/30.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import WatchKit
import Foundation


class KFWatchTimeSelectorInterfaceController: WKInterfaceController {

    @IBOutlet weak var tbvDayInterval: WKInterfaceTable!
    var dayInterval:Array<String>!
    
    let notimeAlert = "notime"
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let notime:[String] = [notimeAlert]
        let timeInterval = context as! Array<String>

        self.dayInterval = notime + timeInterval
        println("self.dayInterval:\(self.dayInterval)")
        
        self.tbvDayInterval.setNumberOfRows(self.dayInterval.count, withRowType: "KFWatchTimeSelectorCell")
        
        for (idx, title) in enumerate(self.dayInterval) {
            let cell = self.tbvDayInterval.rowControllerAtIndex(idx) as! KFWatchTimeSelectorCell
            if (title == notimeAlert) {
                cell.lblSelectorTime.setText("KF_NO_REMIND".localized)
            } else {
                cell.lblSelectorTime.setText(title)
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let selectDayInterval = self.dayInterval[rowIndex]
        println("selectDayInterval:\(selectDayInterval)")
        self.presentTextInputControllerWithSuggestions(nil, allowedInputMode: WKTextInputMode.Plain) { (input) -> Void in
            println("INPUT:\(input)")
            if (input == nil) {
                self.popToRootController()
            } else {
                if (input.isEmpty == false) {
                    let inputText = input[0] as! String
                    self.createEventWithContent(inputText, and: selectDayInterval)
                } else {
                    self.popToRootController()
                }
            }
        }

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    // MARK: - Private Methods
    func createEventWithContent(content:String, and alertTime:String) ->Void {
        var eventDO: KFEventDO = KFEventDO()
        eventDO.content = content
        if (alertTime != notimeAlert) {
            let alertTimeString = KFUtil.getShortDate(NSDate()) + " " + alertTime
            let alertTimeDate = KFUtil.getDateByString(alertTimeString)
            let alertTimeStamp = alertTimeDate.timeIntervalSince1970
            eventDO.starttime = NSNumber(double: alertTimeStamp)
        }
        if (eventDO.status == nil) {
            eventDO.status = NSNumber(integerLiteral: KEventStatus.Normal.rawValue)
        }
        
        let eventId = KFEventDAO.sharedManager.saveEvent(eventDO) as NSNumber
        
        let newTaskUserInfo = [KF_WK_OPEN_PARENT_APPLICATION_NEW_TASK: eventId]
        WKInterfaceController.openParentApplication(newTaskUserInfo, reply: { (result, error) -> Void in
            
        })
        
        self.popToRootController()
    }
}
