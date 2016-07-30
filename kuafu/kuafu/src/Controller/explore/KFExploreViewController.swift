//
//  KFExploreViewController.swift
//  kuafu
//
//  Created by Vienta on 15/8/17.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFExploreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    // MARK: - Property
    @IBOutlet weak var tbvExplore: UITableView!
    var exploreItem: Array<String>!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.exploreItem = ["KF_ONE_KEY_RELEASE".localized]
        self.title = "KF_EXPLORE_TITLE".localized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    // MARK: - Private Methods
    // MARK: - Public Methods
    // MARK: - UITaleViewDelegate && UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.exploreItem.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "exploreIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)! as UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        cell?.textLabel?.text = self.exploreItem[indexPath.row] as String
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }    
}
