//
//  KFBaseModelDO.swift
//  kuafu
//
//  Created by Vienta on 15/6/5.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFBaseModelDO: NSObject {
    
    override init() {
        super.init()
    }
    
    init(initWithDict dict:NSDictionary) {
        super.init()
        dict.enumerateKeysAndObjectsUsingBlock { (key, obj, stop) -> Void in
            let SEL: Selector = NSSelectorFromString(key as! String);
            
            if (self.respondsToSelector(SEL)) {
//                if (obj == nil) {
//                    self.setNilValueForKey(key as! String)
//                } else {
                    self.setValue(obj, forKey: key as! String)
//                }
            }
        }
        
    }
    
}
