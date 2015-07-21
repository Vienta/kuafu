//
//  KFVersionsViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/20.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFVersionsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbvVersions: UITableView!
    var versions: Array<Dictionary<String,String>>!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "KF_SETTINGS_HISTORY_VERSION".localized
        self.versions = [["versionTitle":APP_DISPLAY_NAME + APP_VERSION + "KF_UPDATE_DESC".localized,"publishtime":"2015年8月8日"]]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - IBActions
    // MARK: - Private Methods
    // MARK: - Public Methods
    // MARK: - UITableViewDelegate && UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.versions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "versionsCellIdentifier"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        var rowVersionInfo: Dictionary = self.versions[indexPath.row]
        cell.textLabel?.text = rowVersionInfo["versionTitle"]
        cell.detailTextLabel?.text = rowVersionInfo["publishtime"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
}
