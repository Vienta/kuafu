//
//  InterfaceController.swift
//  kuafu WatchKit Extension
//
//  Created by Vienta on 15/7/23.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tbvEvent: WKInterfaceTable!
    
    let minions = ["KFWatchEvensTableHeaderController", "KFWatchEventsTableRowController", "KFWatchEvensTableHeaderController", "KFWatchEventsTableRowController", "KFWatchEventsTableRowController"]
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.tbvEvent.setRowTypes(self.minions)
        
        for (idx, name) in enumerate(self.minions) {
            if (name == "KFWatchEventsTableRowController" ) {
                let row = self.tbvEvent.rowControllerAtIndex(idx) as! KFWatchEventsTableRowController
                row.lblEventContent.setText(name)
            } else {
                let header = self.tbvEvent.rowControllerAtIndex(idx) as! KFWatchEvensTableHeaderController
                header.lblHeader.setText("title")
            }
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
