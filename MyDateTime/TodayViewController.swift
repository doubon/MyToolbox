//
//  TodayViewController.swift
//  MyDateTime
//
//  Created by doubon on 16/4/28.
//  Copyright © 2016年 doubon. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var lblDateTime: UILabel!
    
    fileprivate var _dateformatter: DateFormatter!
    fileprivate var _timer: Timer!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        _dateformatter = DateFormatter()
        _dateformatter.dateFormat = "HH:mm:ss"
        
        lblDateTime.text = _dateformatter.string(from: Date())
        _timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(timerFireMethod), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    @objc func timerFireMethod(_ timer: Timer) {
        lblDateTime.text = _dateformatter.string(from: Date())
    }
}
