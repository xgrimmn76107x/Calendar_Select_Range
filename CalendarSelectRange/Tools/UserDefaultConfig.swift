//
//  UserDefaultConfig.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7.
//

import Foundation
import SwiftyUserDefaults

// 設定UserDefault 群組
var Defaults = DefaultsAdapter<DefaultsKeys>(defaults: UserDefaults(suiteName: "com.jay.app")!, keyStore: .init())

// 設定UserDefault Key
extension DefaultsKeys {
    /// 設定車主或客人
    var UserIsOwner: DefaultsKey<Bool> { .init("UserIsOwner", defaultValue: false) }
    /// 設定客人租車時間
    var customerSelectDate: DefaultsKey<TimeDisplay> { .init("customer_rent_date", defaultValue: TimeDisplay())}
}

