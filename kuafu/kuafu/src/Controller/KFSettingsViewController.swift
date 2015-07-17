//
//  KFSettingsViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/16.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import StoreKit

class KFSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate {
   
    @IBOutlet weak var tbvSettings: UITableView!
    var settingsList: NSMutableArray!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KF_BG_COLOR
        self.title = "KF_SETTINGS_CONTROLLER_TITLE".localized
        
        var settings =  [["section":"通用","values":[KF_SHAKE_CREATE_TASK]],
                        ["section":"反馈","values":[KF_FEEDBACK,KF_EVALUATION]],
                        ["section":"关于","values":[KF_ABOUT_KUAFU,KF_HISTORY_VERSION,KF_LISENCE]]]
        
        self.settingsList = NSMutableArray(array: settings)
        self.tbvSettings.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    // MARK: - Private Methods
    func switchValueChanged(sender:AnyObject) -> Void {
        let sw = sender as! UISwitch
        NSUserDefaults.standardUserDefaults().setBool(sw.on, forKey: KF_SHAKE_CREATE_TASK)
    }
    
    func openAppStore() -> Void {
        var storeProductViewController: SKStoreProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = self
        storeProductViewController.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: "594467299"], completionBlock: { (result, error) -> Void in
            if (error == nil) {
                self.presentViewController(storeProductViewController, animated: true, completion: nil)
            }
        })
    }
    
    func targetAction(actionKey: String) ->Void {
        switch (actionKey) {

        case (KF_EVALUATION):
            self.openAppStore()
        case (KF_ABOUT_KUAFU):
            println("afd")
        case (KF_HISTORY_VERSION):
            println("afd")
        case (KF_LISENCE):
            println("afd")
        default:
            println("afd")
        }
    }
    
    // MARK: - Public Methods

    // MARK: - UITableViewDataSource && UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.settingsList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let elementInSectionDict: NSDictionary = self.settingsList.objectAtIndex(section) as! NSDictionary
        let elementsInSection: NSArray = elementInSectionDict.objectForKey("values") as! NSArray
        
        return elementsInSection.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "settingsIdentifier"
        var settingsCell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if (settingsCell == nil) {
            settingsCell = UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier)
            settingsCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
        let elementInSectionDict: NSDictionary = self.settingsList.objectAtIndex(indexPath.section) as! NSDictionary
        let elementsInSection: NSArray = elementInSectionDict.objectForKey("values") as! NSArray
        
        let elementValueKey: String = elementsInSection.objectAtIndex(indexPath.row) as! String
        
        settingsCell.textLabel?.text = KF_SETTINGS[elementValueKey]
        
        if (elementValueKey == KF_SHAKE_CREATE_TASK) {
            var on:Bool = NSUserDefaults.standardUserDefaults().boolForKey(KF_SHAKE_CREATE_TASK)
            var shakeSwith: UISwitch = UISwitch()
            shakeSwith.on = on
            shakeSwith.addTarget(self, action: "switchValueChanged:", forControlEvents: UIControlEvents.TouchUpInside)
            settingsCell.accessoryView = shakeSwith
        }
        
        return settingsCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let elementInSectionDict: NSDictionary = self.settingsList.objectAtIndex(indexPath.section) as! NSDictionary
        let elementsInSection: NSArray = elementInSectionDict.objectForKey("values") as! NSArray
        
        let elementValueKey: String = elementsInSection.objectAtIndex(indexPath.row) as! String
        self.targetAction(elementValueKey)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let elementInSectionDict: NSDictionary = self.settingsList.objectAtIndex(section) as! NSDictionary
        return elementInSectionDict.objectForKey("section") as? String
    }
    
    // MARK: - SKStoreProductViewControllerDelegate
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
