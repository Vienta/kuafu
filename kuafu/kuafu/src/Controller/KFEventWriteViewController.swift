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

class KFEventWriteViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var txfEventTitle: UITextField!
    @IBOutlet weak var txvEventContent: UITextView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var cancelItem = UIBarButtonItem(title: "KF_CANCEL".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelItem
        
        var saveItem = UIBarButtonItem(title: "KF_SAVE".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        self.navigationItem.rightBarButtonItem = saveItem
        saveItem.enabled = false
        
        var eventAlertKeyboard: KFEventAlertKeyboard = KFEventAlertKeyboard.keyboard()
        eventAlertKeyboard.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.85, alpha: 1)
        self.txvEventContent.inputAccessoryView = eventAlertKeyboard
        self.txfEventTitle.inputAccessoryView = eventAlertKeyboard
        
        eventAlertKeyboard.tapBlock = ({
            (tap: kTapStyle) -> Void in
            if tap == kTapStyle.Alert {
                println("alert")
                self.popTimePickerView()
            } else {
                println("dateto")
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.txvEventContent.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    func cancel() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        
    }
    
    func popTimePickerView() {
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
    }
    
    func dismissTimePickerView() {
        var timePickerView: UIButton = objc_getAssociatedObject(self, &kAssociateKey) as! UIButton
        UIView.animateWithDuration(0.18, animations: { () -> Void in
            timePickerView.alpha = 0.0
        }) { (Bool) -> Void in
            timePickerView.removeFromSuperview()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
