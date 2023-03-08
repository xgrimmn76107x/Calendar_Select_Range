//
//  CalendarVM.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7 5:30 PM.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftDate
import SwiftyUserDefaults


class JayCalendarVM {
    
    // MARK: Output
    
    // MARK: 開始與結束日期
    /// 開始日期Driver
    var startDateDriver: Driver<String> {
        return startDatePublish.asDriver(onErrorJustReturn: "開始日期")
    }
    
    /// 結束日期Driver
    var endDateDriver: Driver<String> {
        return endDatePublish.asDriver(onErrorJustReturn: "結束日期")
    }
    
    // MARK: 開始與結束時間
    /// 開始時間Driver
    var startTimeDriver: Driver<String> {
        return startTimePublish.asDriver(onErrorJustReturn: "")
    }
    
    /// 結束時間Driver
    var endTimeDriver: Driver<String> {
        return endTimePublish.asDriver(onErrorJustReturn: "")
    }
    
    // MARK: 開始與結束Slider的值
    /// 設定開始時間的Slider值
    var startTimeSliderValueObs: Observable<Float> {
        return startTimeSliderValuePublish.asObservable()
    }
    /// 設定結束時間的Slider值
    var endTimeSliderValueObs: Observable<Float> {
        return endTimeSliderValuePublish.asObservable()
    }
    
    /// 判斷是否要顯示”開始“日期的字樣
    var startLabelObs: Observable<Bool> {
        return startLabelHiddenPublish.asObservable()
    }
    /// 判斷是否要顯示”結束“日期的字樣
    var endLabelObs: Observable<Bool> {
        return endLabelHiddenPublish.asObservable()
    }
    
    /// 當需要取消點擊以外的日期時使用（當已經點選完開始日期與結束日期再點擊的時會使用｜｜點選結束的日期比開始的日期早時也會使用）
    var selectDateObs: Observable<DateInRegion> {
        return selectDatePublish.asObservable()
    }
    // MARK: 取得開始與結束時間Slider對應的值（0 ~ 47）
    var startSliderTimeValue: Float {
        return startTime.dateInRegionToSliderIndex()
    }
    var endSliderTimeValue: Float {
        return endTime.dateInRegionToSliderIndex()
    }
    
    // MARK: 取得開始時間的最大值
    var maxStartSliderTimeValue: Float {
        return Float(47 - (endTimeSpacing * 2)) // 主要是看開始與結束的最短間距
    }
    
    // MARK: 取得開始時間的最小值
    var minStartSliderTimeValue: Float {
        return Date().easyConvertToTaipeiZone.dateRoundedAt(.toCeil30Mins).dateInRegionToSliderIndex(addTime: startTimeSpacing, component: startTimeComponent)
    }
    // MARK: 取得結束時間的最小值
    var minEndSliderTimeValue: Float {
        return startTime.dateInRegionToSliderIndex(addTime: endTimeSpacing, component: endTimeComponent)
    }
    // MARK: 顯示組共的時間（幾晚）
    var totalTimeObs: Observable<String> {
        return self.totalTimePublish.asObservable()
    }
    
    // MARK: - Input
    
    init() {
        startDatePublish.onNext(startDate.easyToFormat("EE, MM/dd"))
        startTimePublish.onNext(startTime.easyToFormat("h:mm a"))
        endDatePublish.onNext(endDate.easyToFormat("EE, MM/dd"))
        endTimePublish.onNext(endTime.easyToFormat("h:mm a"))
        totalTimePublish.onNext("共\(DateInRegion.enumerateDates(from: startDate, to: endDate, increment: DateComponents.create({$0.day = 1})).count - 1)晚")
    }
    
    // MARK: - Private
    
    private let startDatePublish = ReplaySubject<String>.create(bufferSize: 1)
    private let endDatePublish = ReplaySubject<String>.create(bufferSize: 1)
    
    private let startTimePublish = ReplaySubject<String>.create(bufferSize: 1)
    private let endTimePublish = ReplaySubject<String>.create(bufferSize: 1)
    
    private let totalTimePublish = ReplaySubject<String>.create(bufferSize: 1)
    
    private let startTimeSliderValuePublish = PublishSubject<Float>()
    private let endTimeSliderValuePublish = PublishSubject<Float>()
    
    private let startLabelHiddenPublish = PublishSubject<Bool>()
    private let endLabelHiddenPublish = PublishSubject<Bool>()
    
    private var selectDatePublish = PublishSubject<DateInRegion>()
    
    /// 開始日期
    var startDate: DateInRegion = JayCalendarManager.shared.startDate {
        didSet {
            startDatePublish.onNext(startDate.easyToFormat("EE, MM/dd"))
        }
    }
    /// 結束日期
    var endDate: DateInRegion = JayCalendarManager.shared.endDate {
        didSet {
            endDatePublish.onNext(endDate.easyToFormat("EE, MM/dd"))
            
            let components = Calendar.current.dateComponents([.day], from: startDate.date, to: endDate.date)
            totalTimePublish.onNext("共\(DateInRegion.enumerateDates(from: startDate, to: endDate, increment: DateComponents.create({$0.day = 1})).count - 1)晚")
        }
    }
    /// 開始時間
    var startTime: DateInRegion = JayCalendarManager.shared.startTime {
        didSet {
            if isEndTimeNeedMove {
                let end = startTime.dateByAdding(endTimeSpacing, endTimeComponent).dateRoundedAt(.toFloor30Mins)
                guard end.compare(.isSameDay(startTime)) else { return }
                endTime = end
                endTimeSliderValuePublish.onNext(endTime.dateInRegionToSliderIndex())
            }
            startTimePublish.onNext(startTime.easyToFormat("h:mm a"))
        }
    }
    /// 結束時間
    var endTime: DateInRegion = JayCalendarManager.shared.endTime {
        didSet {
            endTimePublish.onNext(endTime.easyToFormat("h:mm a"))
        }
    }
    /// 判斷結束時間的Slider是否需要跟著移動（如果跟開始時間同一天，就不能比開始時間早）
    var isEndTimeNeedMove: Bool {
        return isSameDayClickTwice && endTime.compare(.isEarlier(than: startTime.dateByAdding(endTimeSpacing, endTimeComponent)))
    }
    
    
    /// 判斷開始日期的是否要顯示預設值（假如沒有選開始日期，就是顯示預設值）
    var isStartLabelHidden: Bool = false {
        didSet {
            startLabelHiddenPublish.onNext(isStartLabelHidden)
        }
    }
    /// 判斷結束日期的是否要顯示預設值（假如沒有選結束日期，就是顯示預設值）
    var isEndLabelHidden: Bool = false {
        didSet {
            endLabelHiddenPublish.onNext(isEndLabelHidden)
            if isEndLabelHidden {
                totalTimePublish.onNext("共0晚")
            }
        }
    }
    // 判斷是否為同一天
    var isSameDayClickTwice: Bool = false {
        didSet {
            if isEndTimeNeedMove {
                let end = startTime.dateByAdding(1, .hour)
                guard end.compare(.isSameDay(startTime)) else { return }
                endTime = end
                endTimeSliderValuePublish.onNext(endTime.dateInRegionToSliderIndex())
            }
        }
    }
    
    // 如果超過晚上10點半還點選同一天開始與結束，要阻擋（依據開始與結束的最短租借時間而定）
    
    
    // 判斷點選開始的日期是否為今天
    var isStartDateSameDayAsToday: Bool = false {
        didSet {
            if isStartDateSameDayAsToday && startTime.compare(.isEarlier(than: Date().easyConvertToTaipeiZone.dateByAdding(startTimeSpacing, startTimeComponent))) {
                startTime = Date().easyConvertToTaipeiZone.dateByAdding(startTimeSpacing, startTimeComponent).dateRoundedAt(.toCeil30Mins)
                startTimeSliderValuePublish.onNext(startTime.dateInRegionToSliderIndex())
            }
        }
    }
    
    
    // MARK: 如果開始時間跟今天日期相同，決定開始時間與現在時間的間距
    private let startTimeSpacing: Int = 30
    private let startTimeComponent: Calendar.Component = .minute
    
    
    // MARK: 如果開始時間與結束時間相同，決定開始時間與結束時間的間距
    private let endTimeSpacing: Int = 1
    private let endTimeComponent: Calendar.Component = .hour
    
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Functoins
    
    func startDateSetup() {
        startDatePublish.onNext(startDate.easyToFormat("EE, MM/dd"))
        startTimePublish.onNext(startDate.easyToFormat("h:mm a"))
    }
    
    func endDateSetup() {
        endDatePublish.onNext(endDate.easyToFormat("EE, MM/dd"))
        endTimePublish.onNext(endDate.easyToFormat("h:mm a"))
    }
    
    // MARK: - 點選日曆
    func calendarDidselect(_ date: DateInRegion, _ isDuplicate: Bool, _ count: Int) {
        // 如果是從should Deselect 進來的話，count要加1
        isStartDateSameDayAsToday = date.compare(.isSameDay(Date().easyConvertToTaipeiZone))
        isStartLabelHidden = false
        isEndLabelHidden = false
        // 點擊一個日期，只有Reset後才會觸發
        if count == 1 {
            startDate = date
        // 點擊第二個會觸發，如果有點擊重複的也是這
        }else if count == 2 {
            if isDuplicate {
                if self.isSameDayClickTwice {
                    self.isSameDayClickTwice = false
                    startDate = date
                    selectDatePublish.onNext(date)
                    isEndLabelHidden = true
                }else {
                    guard startTime.dateInRegionToSliderIndex() <= maxStartSliderTimeValue else {
                        isEndLabelHidden = true
                        return
                    }
                    self.isSameDayClickTwice = true
                    endDate = date
                }
            }else {
                guard !self.isSameDayClickTwice else {
                    self.isSameDayClickTwice = false
                    startDate = date
                    selectDatePublish.onNext(date)
                    isEndLabelHidden = true
                    return
                }
                if date.compare(.isEarlier(than: startDate)) {
                    startDate = date
                    selectDatePublish.onNext(date)
                    isEndLabelHidden = true
                }else {
                    endDate = date
                    
                }
            }
        }else {
            // 點擊第三個會觸發，如果點擊重複的也是這
            startDate = date
            isEndLabelHidden = true
            selectDatePublish.onNext(date)
        }
    }
    
    // MARK: - Time Slider滑動觸發
    func timeSliderDidChange(_ index: Int, _ slideType: SlideTimeType) {
        let hour = index / 2
        let minute = index % 2 == 0 ? 0 : 30
        switch slideType {
        case .start:
            startTime = startTime.dateBySet(hour: hour, min: minute, secs: 0)!
        case .end:
            endTime = endTime.dateBySet(hour: hour, min: minute, secs: 0)!
        }
        
    }
    
    // MARK: 判斷結束時間是否有早於開始時間，前提是有在同一天的情況底下
    func isEndSliderLess(_ index: Int, _ slideType: SlideTimeType) -> Bool {
        if isSameDayClickTwice {
            return Float(index) < startTime.dateInRegionToSliderIndex(addTime: endTimeSpacing)
        }
        return false
    }
    
    // MARK: 如果選擇今天，確定開始時間沒有早於現在的時間
    func isStartSliderLess(than index: Int) -> Bool {
        if startDate.compare(.isSameDay(Date().easyConvertToTaipeiZone)) {
            return Float(index) < Date().easyConvertToTaipeiZone.dateRoundedAt(.toCeil30Mins).dateInRegionToSliderIndex(addTime: startTimeSpacing, component: startTimeComponent)
        }else {
            return false
        }
    }
    
    // MARK: 如果選擇同一天，確定開始時間不能大於晚上10點半，因為會讓結束時間超過當天晚上11點半
    func isStartSliderMore(than index: Int) -> Bool {
        if isEndTimeNeedMove {
            return Float(index) > Float(maxStartSliderTimeValue)
        }
        return false
    }
    
}



//protocol Stackable {
//    associatedtype Element
//    func peek() -> Element?
//    mutating func push(_ element: Element)
//    @discardableResult mutating func pop() -> Element?
//}
//
//extension Stackable {
//    var isEmpty: Bool { peek() == nil }
//}
//
//struct Stack<Element>: Stackable where Element: Equatable {
//    private var storage = [Element]()
//    func peek() -> Element? { storage.last }
//    mutating func push(_ element: Element) { storage.append(element)  }
//    mutating func pop() -> Element? { storage.popLast() }
//}
//
//extension Stack: Equatable {
//    static func == (lhs: Stack<Element>, rhs: Stack<Element>) -> Bool { lhs.storage == rhs.storage }
//}
//
//extension Stack: CustomStringConvertible {
//    var description: String { "\(storage)" }
//}
//
//extension Stack: ExpressibleByArrayLiteral {
//    init(arrayLiteral elements: Self.Element...) { storage = elements }
//}

