//
//  KFEventWriteViewController.swift
//  kuafu
//
//  Created by Vienta on 15/6/9.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit
import ObjectiveC

var kAssociateKey: UInt8 = 0

class KFEventWriteViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    // MARK: - Property
    @IBOutlet weak var txfEventTitle: UITextField!
    @IBOutlet weak var txvEventContent: UITextView!
    var eventDO: KFEventDO!
    var isWritingRemind: Bool!
    var settingTimestamp: NSTimeInterval!
    var eventAlertKeyboard: KFEventAlertKeyboard!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "KF_NEW_TODO_TITLE".localized
        var cancelItem = UIBarButtonItem(title: "KF_CANCEL".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelItem
        
        var saveItem = UIBarButtonItem(title: "KF_SAVE".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        self.navigationItem.rightBarButtonItem = saveItem
        saveItem.enabled = false
        
        self.eventAlertKeyboard = KFEventAlertKeyboard.keyboard()
        eventAlertKeyboard.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.85, alpha: 1)
        self.txvEventContent.inputAccessoryView = eventAlertKeyboard
        self.txfEventTitle.inputAccessoryView = eventAlertKeyboard
        
        eventAlertKeyboard.tapBlock = ({
            (tap: kTapStyle) -> Void in
            if tap == kTapStyle.Alert {
                println("alert")
                self.popTimePickerView("KF_TIME_ALERT".localized)
            } else {
                println("dateto")
                self.popTimePickerView("KF_TIME_DUETO".localized)
            }
        })
        
        self.eventDO = KFEventDO()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.txvEventContent.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB ACTION
    @IBAction func textFieldTextChanged(sender: UITextField){
        self.eventDO.title = sender.text
        println(self.eventDO.title)
    }
    // MARK: - UITextView Delegate
    func textViewDidChange(textView: UITextView) {
        if (textView.text.isEmpty == true) {
            self.navigationItem.rightBarButtonItem?.enabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        self.eventDO.content = textView.text
    }
    
    // MARK: - Private Methods
    func cancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.view.endEditing(true)
    }
    
    func save() {
        println(self.eventDO)
        if self.eventDO.content.isEmpty == true {
            var tipsAlert: UIAlertView = UIAlertView(title: "KF_ALERT_TIPS".localized, message: "KF_ALERT_NULL_CONTENT".localized, delegate: nil, cancelButtonTitle: "KF_OK".localized)
            tipsAlert.show()
            return
        }
        
        if (self.eventDO.starttime != nil && self.eventDO.endtime != nil) {
            if self.eventDO.endtime.doubleValue > 0 && self.eventDO.endtime.doubleValue < self.eventDO.starttime.doubleValue {
                var tipsAlert: UIAlertView = UIAlertView(title: "KF_ALERT_TIPS".localized, message: "KF_ALERT_TIMESTAMP_ERROR".localized, delegate: nil, cancelButtonTitle: "KF_OK".localized)
                tipsAlert.show()
                return
            }
        }
        
        if (self.eventDO.starttime != nil) {
            if self.eventDO.starttime.doubleValue > 0 && self.eventDO.starttime.doubleValue < NSDate().timeIntervalSince1970 {
                var tipsAlert: UIAlertView = UIAlertView(title: "KF_ALERT_TIPS".localized, message: "KF_ALERT_TIMMSTAMP_STARTTIME_ERROR".localized, delegate: nil, cancelButtonTitle: "KF_OK".localized)
                tipsAlert.show()
                return
            }
        }
        
        if (self.eventDO.endtime != nil) {
            if self.eventDO.endtime.doubleValue > 0 && self.eventDO.endtime.doubleValue < NSDate().timeIntervalSince1970 {
                var tipsAlert: UIAlertView = UIAlertView(title: "KF_ALERT_TIPS".localized, message: "KF_ALERT_TIMMSTAMP_STARTTIME_ERROR".localized, delegate: nil, cancelButtonTitle: "KF_OK".localized)
                tipsAlert.show()
                return
            }
        }
        if (self.eventDO.status == nil) {
            self.eventDO.status = NSNumber(integerLiteral: KEventStatus.Normal.rawValue)
        }

        KFEventDAO.sharedManager.saveEvent(self.eventDO)
        self.cancel()
    }
    
    func popTimePickerView(title: String) {
        self.view.endEditing(true)
        
        var btnTimePickerBg: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btnTimePickerBg.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        btnTimePickerBg.addTarget(self, action: "dismissTimePickerView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnTimePickerBg)
        btnTimePickerBg.alpha = 0.0
        btnTimePickerBg.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        
        objc_setAssociatedObject(self, &kAssociateKey, btnTimePickerBg, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        
        var timePickerView: KFEventTimePickerAlertView = NSBundle.mainBundle().loadNibNamed("KFEventTimePickerAlertView", owner: nil, options: nil)[0] as! KFEventTimePickerAlertView
        btnTimePickerBg.addSubview(timePickerView)
        timePickerView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(btnTimePickerBg)
            make.leading.equalTo(btnTimePickerBg).offset(20)
            make.trailing.equalTo(btnTimePickerBg).offset(-20)
            make.height.equalTo(250)
        }
        KFUtil.drawCornerView(timePickerView, radius: 4)
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            btnTimePickerBg.alpha = 1.0
        }, completion: nil)
        
        timePickerView.btnCancel.addTarget(self, action: "deleteRemindTime:", forControlEvents: UIControlEvents.TouchUpInside)
        timePickerView.btnConfirm.addTarget(self, action: "saveRemindTime:", forControlEvents: UIControlEvents.TouchUpInside)
        timePickerView.datePickerAlert.addTarget(self, action: "dataPickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        timePickerView.lblTitle.text = title
        
        if ("KF_TIME_ALERT".localized == title) == true {
            isWritingRemind = true
            if (self.eventDO.starttime != nil && self.eventDO.starttime.doubleValue > 0) {
                timePickerView.datePickerAlert.date = KFUtil.dateFromTimeStamp(self.eventDO.starttime.doubleValue)
            }
        }
    
        if ("KF_TIME_DUETO".localized == title) == true {
            isWritingRemind = false
            if (self.eventDO.endtime != nil && self.eventDO.endtime.doubleValue > 0) {
                timePickerView.datePickerAlert.date = KFUtil.dateFromTimeStamp(self.eventDO.endtime.doubleValue)
            }
        }
        
        settingTimestamp = NSDate().timeIntervalSince1970
    }
    
    func dismissTimePickerView() {
        var timePickerView: UIButton = objc_getAssociatedObject(self, &kAssociateKey) as! UIButton
        UIView.animateWithDuration(0.18, animations: { () -> Void in
            timePickerView.alpha = 0.0
        }) { (Bool) -> Void in
            timePickerView.removeFromSuperview()
            self.txvEventContent.becomeFirstResponder()
        }
    }
    
    func dataPickerChanged(datePicker: UIDatePicker) {
        var settingDate: NSDate = datePicker.date
        var timestamp: NSTimeInterval = datePicker.date.timeIntervalSince1970

        settingTimestamp = timestamp
    }
    
    func saveRemindTime(sender: UIButton) {
        var timePickerView: KFEventTimePickerAlertView = sender.superview as! KFEventTimePickerAlertView
        timePickerView.datePickerAlert.removeTarget(self, action: "dataPickerChanged", forControlEvents: UIControlEvents.ValueChanged)

        if isWritingRemind == true {
            self.eventDO.starttime = NSNumber(double: settingTimestamp)
            self.eventAlertKeyboard.btnAlert.tintColor = KF_THEME_COLOR    
        } else {
            self.eventDO.endtime = NSNumber(double: settingTimestamp)
            self.eventAlertKeyboard.btnDateto.tintColor = KF_THEME_COLOR
        }
        self.dismissTimePickerView()
    }
    
    func deleteRemindTime(sender: UIButton) {
        if isWritingRemind == true {
            self.eventDO.starttime = nil
            self.eventAlertKeyboard.btnAlert.tintColor = KF_ICON_BG_COLOR
        } else {
            self.eventDO.endtime = nil
            self.eventAlertKeyboard.btnDateto.tintColor = KF_ICON_BG_COLOR
        }
        self.dismissTimePickerView()
    }
    
}
