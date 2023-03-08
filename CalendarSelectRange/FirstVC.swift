//
//  FirstVC.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import UIKit
import SwiftDate

class FirstVC: UIViewController {

    @IBOutlet weak var calendarBtn: UIButton!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDate()
        
        calendarBtn.setCornerRadius(10)
        calendarBtn.setTitle("日期", for: .normal)
    }
    
    func setupDate() {
        startDateLabel.text = JayCalendarManager.shared.startDate.easyToFormat("yyyy-MM-dd")
        endDateLabel.text = JayCalendarManager.shared.endDate.easyToFormat("yyyy-MM-dd")
        
        startTimeLabel.text = JayCalendarManager.shared.startTime.easyToFormat("HH:mm")
        endTimeLabel.text = JayCalendarManager.shared.endTime.easyToFormat("HH:mm")
    }
    


     @IBAction func btnPressed(_ sender: Any) {
         let vc = JayCalendarVC()
         Tools.presentWithUINavigationOnTop(vc)
     }

}
