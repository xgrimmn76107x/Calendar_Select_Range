//
//  CalendarManager.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import UIKit
import SwiftyUserDefaults
import SwiftDate


class JayCalendarManager {
    
    static let shared = JayCalendarManager()
    
    var startDate: DateInRegion!
    
    var endDate: DateInRegion!
    
    var startTime: DateInRegion!
    
    var endTime: DateInRegion!
    
    
    init() {
        startDate = Defaults[\.customerSelectDate].startDate
        endDate = Defaults[\.customerSelectDate].endDate
        startTime = Defaults[\.customerSelectDate].startTime
        endTime = Defaults[\.customerSelectDate].endTime
    }
    
    func saveStartAndEnd(_ startDate: DateInRegion, _ startTime: DateInRegion, _ endDate: DateInRegion, _ endTime: DateInRegion) {
        self.startDate = startDate
        self.startTime = startTime
        self.endDate = endDate
        self.endTime = endTime
    }
}
