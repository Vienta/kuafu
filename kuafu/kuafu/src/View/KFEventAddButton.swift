//
//  KFEventAddButton.swift
//  kuafu
//
//  Created by Vienta on 15/6/6.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFEventAddButton: UIButton {
    
//    var horizontalLayer: CAShapeLayer!
//    var verticalLayer: CAShapeLayer!

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.backgroundColor = KF_THEME_COLOR

        let horizontalPath = UIBezierPath(rect: CGRectMake(10, CGRectGetMidY(rect) - 1.5, CGRectGetWidth(rect) - 20, 3))
        UIColor.whiteColor().setFill()
        horizontalPath.fill()
        
        let verticalPath = UIBezierPath(rect: CGRectMake(CGRectGetMidX(rect) - 1.5, 10, 3, CGRectGetHeight(rect) - 20))
        UIColor.whiteColor().setFill()
        verticalPath.fill()
    }
}
