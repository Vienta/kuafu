//
//  KFEventWriteViewController.swift
//  kuafu
//
//  Created by Vienta on 15/6/9.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
