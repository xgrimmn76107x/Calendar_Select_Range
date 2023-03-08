//
//  CalendarModel.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import SwiftDate
import SwiftyUserDefaults
import FSCalendar


struct TimeDisplay: Codable, DefaultsSerializable {
    
    /// 開始日期
    var startDate: DateInRegion = Date().dateByAdding(2, .day).easyConvertToTaipeiZone
    /// 結束日期
    var endDate: DateInRegion = Date().dateByAdding(5, .day).easyConvertToTaipeiZone
    
    /// 開始時間
    var startTime: DateInRegion = Date().easyConvertToTaipeiZone.dateBySet(hour: 10, min: 0, secs: 0)!
    /// 結束時間
    var endTime: DateInRegion = Date().easyConvertToTaipeiZone.dateBySet(hour: 10, min: 0, secs: 0)!
    
}


enum SlideTimeType {
    case start
    case end
}


class TWFSCalendar: FSCalendar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setValue(TimeZone(identifier: Zones.asiaTaipei.rawValue), forKey: "timeZone")
        perform(NSSelectorFromString("invalidateDateTools"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

