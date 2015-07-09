//
//  KFCalendarViewController.swift
//  kuafu
//
//  Created by Vienta on 15/7/9.
//  Copyright (c) 2015年 www.vienta.me. All rights reserved.
//

import UIKit

class KFCalendarViewController: UIViewController, ZoomTransitionProtocol {
    // MARK: - Property
    @IBOutlet weak var igvCalendar: UIImageView!
    
    // MARK: - IBActions
    // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()

        println("\(__FUNCTION__)")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("\(__FUNCTION__)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private Methods
    // MARK: - Public Methods
  
    // MARK: - ZoomTransitionProtocol
    func viewForTransition() -> UIView {
        println("\(__FUNCTION__)")
        return self.igvCalendar
    }
}
