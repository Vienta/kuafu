//
//  ViewController.swift
//  kuafu
//
//  Created by Vienta on 15/6/4.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit


class KFEventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.    
        KFEventDAO.sharedManager
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

