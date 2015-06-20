//
//  KFEventAlertKeyboard.swift
//  kuafu
//
//  Created by Vienta on 15/6/19.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFEventAlertKeyboard: UIView {
    var btnAlert: UIButton!
    var btnDateto: UIButton!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnAlert = UIButton(frame: CGRectMake(0, 0, 30, 30))
        self.addSubview(self.btnAlert)
        
    }
}
