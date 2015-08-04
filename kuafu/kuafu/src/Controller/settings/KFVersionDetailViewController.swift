//
//  KFVersionDetailViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/22.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFVersionDetailViewController: UIViewController {

    @IBOutlet weak var txvVersion: UITextView!
    
    var version: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var versionFileName: String = "Version_" + self.version
        let path = NSBundle.mainBundle().pathForResource(versionFileName, ofType: "txt")
        var versionConent: String! = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        self.txvVersion.text = versionConent
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
