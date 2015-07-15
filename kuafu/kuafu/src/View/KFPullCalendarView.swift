//
//  KFPullCalendarView.swift
//  kuafu
//
//  Created by Vienta on 15/7/9.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFPullCalendarView: UIView {

    @IBOutlet weak var lblToday: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        
        let dateString = dateFormatter.stringFromDate(NSDate())
        self.lblToday.text = dateString
    }
}
