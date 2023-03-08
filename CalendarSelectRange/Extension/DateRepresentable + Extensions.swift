//
//  DateRepresentable + Extensions.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import UIKit
import SwiftDate

extension DateRepresentable {
    var easyConvertToTaipeiZone: DateInRegion {
        return DateInRegion(date, region: Region(zone: Zones.current))
    }
    
    var easyConvertToGMTZone: DateInRegion {
        return DateInRegion(date, region: Region(zone: Zones.gmt))
    }
    
    func easyToFormat(_ format: String) -> String {
        return toFormat(format, locale: Locales.chineseTaiwan)
    }
    
    // MARK: - 將Start & End Time轉換成Slider對應的Index
    func dateInRegionToSliderIndex( addTime: Int = 0, component: Calendar.Component = .hour) -> Float {
        return Float((date.easyConvertToTaipeiZone.dateByAdding(addTime, component).hour * 2) + (date.easyConvertToTaipeiZone.dateByAdding(addTime, component).minute == 30 ? 1 : 0))
    }
}
