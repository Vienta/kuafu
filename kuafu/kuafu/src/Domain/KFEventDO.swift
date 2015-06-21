//
//  KFEventDO.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFEventDO: KFBaseModelDO {

    var eventid: NSNumber!
    var title: String!
    var content: String!
    var starttime: NSNumber!
    var endtime: NSNumber!
    var updatetime: NSNumber!
    var creattime: NSNumber!
    var longitude: NSNumber! //经度
    var latitude: NSNumber!  //纬度
    var status: NSNumber!
}
