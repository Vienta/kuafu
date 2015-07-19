//
//  KFLisenceViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/18.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFLisenceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var lisences: Array<String>!
    @IBOutlet weak var tbvLisence: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "KF_SETTINGS_LISENCE".localized
        self.lisences = ["FMDB","SnapKit","MGSwipeTableViewCell","CVCalendarKit","JTCalendar","MKEventKit","DAAlertController","DeviceGuru","ZoomTransition","NJKWebViewProgress"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDelegate && UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lisences.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Thanks for your opensource"
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Generated by CocoaPods \n http://cocoapods.org"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier: String = "KFLisenceCellIdentifier"
        var lisenceCell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if (lisenceCell == nil) {
            lisenceCell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
            lisenceCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        let cellContent: String = self.lisences[indexPath.row]
        lisenceCell.textLabel?.text = cellContent
        
        return lisenceCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cellContent: String = self.lisences[indexPath.row]
        
        var lisenceDetailViewController: KFLisenceDetailViewController = KFLisenceDetailViewController(nibName: "KFLisenceDetailViewController", bundle: nil)
        lisenceDetailViewController.lisenceName = cellContent
        self.navigationController?.pushViewController(lisenceDetailViewController, animated: true)
    }
}
