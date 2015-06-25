//
//  ViewController.swift
//  kuafu
//
//  Created by Vienta on 15/6/4.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit


class KFEventViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    // MARK: -- property --
    @IBOutlet weak var tbvEvents: UITableView!
    @IBOutlet weak var btnEvents: UIButton!
    var events: NSMutableArray!
    
    // MARK: -- IBActions --
    @IBAction func btnTapped(sender: AnyObject) {
        var eventWriteViewController: KFEventWriteViewController = KFEventWriteViewController(nibName: "KFEventWriteViewController", bundle: nil)
        var eventWriteNavigationController: UINavigationController = UINavigationController(rootViewController: eventWriteViewController)
        self.navigationController?.presentViewController(eventWriteNavigationController, animated: true, completion: nil)
    }
    
    // MARK: -- Life Cycle --
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.btnEvents.backgroundColor = KF_THEME_COLOR
        KFUtil.drawCircleView(self.btnEvents)
        self.title = "KF_EVENT_CONTROLLER_TITLE".localized
        self.tbvEvents.rowHeight = UITableViewAutomaticDimension
        self.tbvEvents.estimatedRowHeight = 78.0

        var allEvents: NSArray = KFEventDAO.sharedManager.getAllEvents()
        self.events = NSMutableArray(array: allEvents)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -- UITableViewDelegate && UITableViewDataSource --
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var eventCell: KFEventCell = LOAD_NIB("KFEventCell") as! KFEventCell
        var eventDO: KFEventDO = self.events[indexPath.row] as! KFEventDO
        eventCell.configData(eventDO)
        return eventCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

