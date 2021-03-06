//
//  KFEventCell.swift
//  kuafu
//
//  Created by Vienta on 15/6/23.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class KFEventCell: MGSwipeTableCell{
    @IBOutlet weak var lblMark: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblDueTime: UILabel!
    @IBOutlet weak var igvDue: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        KFUtil.drawCircleView(self.lblMark, borderColor: KF_THEME_COLOR, borderWidth: 1.0)
    }
    
    func configData(eventDO: KFEventDO) {
        if eventDO.title != nil && eventDO.title.isEmpty == false {
            self.lblTitle.text = eventDO.title
        } else {
            self.lblTitle.text = ""
        }
        
        //TODO:2015年06月25日23:13:24 脑袋不清楚时候写的 后面需要优化
        if eventDO.starttime == 0 && eventDO.endtime == 0 {
            self.lblDueTime.text = ""
            self.igvDue.image = nil
        } else if eventDO.starttime != 0 && eventDO.endtime == 0 {
            if eventDO.starttime.doubleValue > NSDate().timeIntervalSince1970 {
                self.igvDue.image = UIImage(named: "btn_datealert")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = KF_THEME_COLOR
            } else {
                self.igvDue.image = UIImage(named: "btn_datealert")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = UIColor.redColor()
            }
            
            var tmpDate: NSDate =  KFUtil.dateFromTimeStamp(eventDO.starttime.doubleValue) as NSDate
            
            self.lblDueTime.text = self.todayString(tmpDate)
            
        } else if eventDO.starttime == 0 && eventDO.endtime != 0 {
            if eventDO.endtime.doubleValue > NSDate().timeIntervalSince1970 {
                self.igvDue.image = UIImage(named: "btn_dateto")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = KF_THEME_COLOR
            } else {
                self.igvDue.image = UIImage(named: "btn_dateto")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = UIColor.redColor()
            }
            
            var tmpDate: NSDate =  KFUtil.dateFromTimeStamp(eventDO.endtime.doubleValue) as NSDate
            
            self.lblDueTime.text = self.todayString(tmpDate)
            
        } else if eventDO.starttime != 0 && eventDO.endtime != 0 {
            println(eventDO.starttime)
            if NSDate().timeIntervalSince1970  <  eventDO.starttime.doubleValue {
                self.igvDue.image = UIImage(named: "btn_datealert")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = KF_THEME_COLOR
                var tmpDate: NSDate = KFUtil.dateFromTimeStamp(eventDO.starttime.doubleValue) as NSDate
                self.lblDueTime.text = self.todayString(tmpDate)
            } else if NSDate().timeIntervalSince1970 > eventDO.starttime.doubleValue && NSDate().timeIntervalSince1970 < eventDO.endtime.doubleValue {
                self.igvDue.image = UIImage(named: "btn_dateto")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = KF_THEME_COLOR
                var tmpDate: NSDate = KFUtil.dateFromTimeStamp(eventDO.endtime.doubleValue)
                self.lblDueTime.text = self.todayString(tmpDate)
                
            } else {
                self.igvDue.image = UIImage(named: "btn_dateto")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                self.igvDue.tintColor = UIColor.redColor()
                var tmpDate: NSDate = KFUtil.dateFromTimeStamp(eventDO.endtime.doubleValue)
                self.lblDueTime.text = self.todayString(tmpDate)
            }
        }
        
        self.lblContent.text = eventDO.content
        
        var markString: String!
        
        if self.lblTitle.text?.isEmpty == false {
            markString = self.lblTitle.text
        } else {
            markString = self.lblContent.text
        }

        var subString: String = markString.substringToIndex(advance(markString.startIndex, 1))
        self.lblMark.text = subString
    }
    
    func todayString(date: NSDate) -> String {
        var tmpDate: NSDate =  date
        
        var isToday: Bool = NSCalendar.currentCalendar().isDateInToday(tmpDate)
        
        var dateString: String!
        if isToday == true {
            dateString = KFUtil.getTodayShortDate(tmpDate)
        } else {
            dateString = KFUtil.getShortDate(tmpDate)
        }

        return dateString
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
