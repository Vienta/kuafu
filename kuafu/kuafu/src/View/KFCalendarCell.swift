//
//  KFCalendarCell.swift
//  kuafu
//
//  Created by Vienta on 15/7/14.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import MKEventKit

class KFCalendarCell: UITableViewCell {

    @IBOutlet weak var lblMorning: UILabel!
    @IBOutlet weak var lblAfternoon: UILabel!
    @IBOutlet weak var lblAllDay: UILabel!
    @IBOutlet weak var sepLine: UIView!
    @IBOutlet weak var lblEventContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.sepLine.backgroundColor = KF_THEME_COLOR
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - loadData
    func configureWithEvent(event: EKEvent, targetDate: NSDate) -> Void {
        if (event.allDay) {
            self.lblMorning.hidden = true
            self.lblAfternoon.hidden = true
            self.lblAllDay.hidden = false
        } else {
            self.lblAllDay.hidden = true
            
            let startTimeIsInToday: Bool = NSCalendar.currentCalendar().isDate(event.startDate, inSameDayAsDate: targetDate)
            if startTimeIsInToday == true {
                self.lblMorning.hidden = false
                self.lblMorning.text = KFUtil.getTodayShortDate(event.startDate)
            } else {
                self.lblMorning.hidden = true
            }
            
            let endTimeIsInToday: Bool = NSCalendar.currentCalendar().isDate(event.endDate, inSameDayAsDate: targetDate)
            if endTimeIsInToday == true {
                if self.lblMorning.hidden == true {
                    self.lblMorning.hidden = false
                    self.lblMorning.text = KFUtil.getTodayShortDate(event.endDate)
                } else {
                    self.lblAfternoon.hidden = false
                    self.lblAfternoon.text = KFUtil.getTodayShortDate(event.endDate)
                }
            } else {
                self.lblAfternoon.hidden = true
            }
        }
        self.lblEventContent.text = event.title
    }
    
}
