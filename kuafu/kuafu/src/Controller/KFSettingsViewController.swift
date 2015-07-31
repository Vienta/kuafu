//
//  KFSettingsViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/16.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI

class KFSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate, MFMailComposeViewControllerDelegate {
   
    @IBOutlet weak var tbvSettings: UITableView!
    var settingsList: NSMutableArray!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KF_BG_COLOR
        self.title = "KF_SETTINGS_CONTROLLER_TITLE".localized
        
        var settings =  [["section":"KF_GENERAL".localized,"values":[KF_SHAKE_CREATE_TASK]],
                        ["section":"KF_FEEDBACK".localized,"values":[KF_FEEDBACK,KF_EVALUATION]],
                        ["section":"KF_ABOUT".localized,"values":[KF_ABOUT_KUAFU,KF_HISTORY_VERSION,KF_LISENCE]]]
        
        self.settingsList = NSMutableArray(array: settings)
        self.tbvSettings.reloadData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView", name: KF_NOTIFICATION_SHAKE_VALUE_CHANGED, object: nil)
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
    
    func openEmailFeedback() -> Void {
        var canSendEmail: Bool = MFMailComposeViewController.canSendMail()
        if (canSendEmail) {
            var mailComposeViewController: MFMailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
        
            var toRecipients: Array = [KF_MY_EMAIL]
            mailComposeViewController.setToRecipients(toRecipients)
                
            
            var emailBody: String = "\(DeviceGuru.hardwareString())|\(APP_DISPLAY_NAME)|Version:\(APP_VERSION)"
            mailComposeViewController.setMessageBody(emailBody, isHTML: true)
            
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func openAppStore() -> Void {
        var storeProductViewController: SKStoreProductViewController = SKStoreProductViewController()
        storeProductViewController.delegate = self
        storeProductViewController.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: "594467299"], completionBlock: { (result, error) -> Void in
            println("product error:\(error)")
            if (error == nil) {
            }
        })
        self.presentViewController(storeProductViewController, animated: true, completion: nil)
    }
    
    func pushToLisence() -> Void {
        var lisenceViewController: KFLisenceViewController = KFLisenceViewController(nibName: "KFLisenceViewController", bundle: nil)

        self.navigationController?.pushViewController(lisenceViewController, animated: true)
    }
    
    func pushToAbout() -> Void {
        var aboutViewController: KFAboutViewController = KFAboutViewController(nibName:"KFAboutViewController", bundle: nil)
        self.navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func pushToHistoryVersion() -> Void {
        var versionsViewController: KFVersionsViewController = KFVersionsViewController(nibName:"KFVersionsViewController", bundle: nil)
        self.navigationController?.pushViewController(versionsViewController, animated: true)
    }
    
    func targetAction(actionKey: String) ->Void {
        switch (actionKey) {

        case (KF_EVALUATION):
            self.openAppStore()
        case (KF_FEEDBACK):
            self.openEmailFeedback()
        case (KF_ABOUT_KUAFU):
            self.pushToAbout()
        case (KF_HISTORY_VERSION):
            self.pushToHistoryVersion()
        case (KF_LISENCE):
            self.pushToLisence()
        default:
            println("afd")
        }
    }
    
    func updateTableView() -> Void {
        self.tbvSettings.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
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
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
