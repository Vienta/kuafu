//
//  KFEventAlertKeyboard.swift
//  kuafu
//
//  Created by Vienta on 15/6/19.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import SnapKit


class KFEventAlertKeyboard: UIView {
    var btnAlert: UIButton!
    var btnDateto: UIButton!
    var tapBlock: ((kTapStyle) -> Void)?
    
    class func keyboard()->KFEventAlertKeyboard{
        
        var keyboard: KFEventAlertKeyboard = KFEventAlertKeyboard(frame: CGRectMake(0, 0, DEVICE_WIDTH, 40))
        keyboard.btnAlert = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        var alertImg = UIImage(named: "btn_datealert")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        keyboard.btnAlert.setImage(alertImg, forState: UIControlState.Normal)
        keyboard.btnAlert.addTarget(keyboard, action: "btnTapped:", forControlEvents: .TouchUpInside)
        keyboard.addSubview(keyboard.btnAlert)
        keyboard.btnAlert.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(keyboard).offset(15)
            make.size.equalTo(CGSizeMake(30, 30))
            make.centerY.equalTo(keyboard)
        }
        keyboard.btnAlert.tintColor = KF_ICON_BG_COLOR
        
        keyboard.btnDateto = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        keyboard.addSubview(keyboard.btnDateto)
        var datetoImg = UIImage(named: "btn_dateto")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        keyboard.btnDateto.setImage(datetoImg, forState: UIControlState.Normal)
        keyboard.btnDateto.addTarget(keyboard, action: "btnTapped:", forControlEvents: .TouchUpInside)
        keyboard.btnDateto.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(keyboard).offset(-15)
            make.size.equalTo(CGSizeMake(30, 30))
            make.centerY.equalTo(keyboard)
        }
        keyboard.btnDateto.tintColor = KF_ICON_BG_COLOR
        return keyboard
    }
    
    func btnTapped(sender: UIButton!) {
        
        if sender.isEqual(self.btnAlert) {
            if ((self.tapBlock) != nil) {
                self.tapBlock!(kTapStyle.Alert)
            }
        } else {
            if ((self.tapBlock) != nil) {
                self.tapBlock!(kTapStyle.DateTo)
            }
        }
    }
}
