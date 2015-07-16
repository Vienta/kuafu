//
//  KFSettingsViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/16.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = KF_BG_COLOR
        self.title = "KF_SETTINGS_CONTROLLER_TITLE".localized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
