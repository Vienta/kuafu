//
//  ViewController.swift
//  kuafu
//
//  Created by Vienta on 15/6/4.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit


class KFEventViewController: UIViewController {

    @IBOutlet weak var tbvEvents: UITableView!
    @IBOutlet weak var btnEvents: UIButton!
    var events: NSMutableArray!
    
    @IBAction func btnTapped(sender: AnyObject) {
        var eventWriteViewController: KFEventWriteViewController = KFEventWriteViewController(nibName: "KFEventWriteViewController", bundle: nil)
        var eventWriteNavigationController: UINavigationController = UINavigationController(rootViewController: eventWriteViewController)
        self.navigationController?.presentViewController(eventWriteNavigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.btnEvents.backgroundColor = KF_THEME_COLOR
        KFUtil.drawCircleView(self.btnEvents)
        self.title = "KF_EVENT_CONTROLLER_TITLE".localized

        var allEvents: NSArray = KFEventDAO.sharedManager.getAllEvents()
        self.events = NSMutableArray(array: allEvents)
        println(self.events)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

