//
//  CalendarVC.swift
//  CalendarSelectRange
//
//  Created by mtaxi on 2023/3/7 5:30 PM.
//


import UIKit
import FSCalendar
import RxSwift
import RxCocoa
import SwiftDate

class JayCalendarVC: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var startTimeSlider: ThumbTextSlider!
    @IBOutlet weak var endTimeSlider: ThumbTextSlider!
    @IBOutlet weak var dateArrowImg: UIImageView!
    
    @IBOutlet weak var showStartDateLabel: UILabel!
    @IBOutlet weak var showEndDateLabel: UILabel!
    
    @IBOutlet weak var saveButton: PressEffectBtn!
    
    
    var viewModel: JayCalendarVM = JayCalendarVM()
    
    private let disposeBag = DisposeBag()
    var oldIndex = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        binding()
        setupCalendar()
        uiSetup()
        sliderSetup()
        navigationSetup("行程日期與時間")
    }
    
    func binding() {
        
        viewModel.totalTimeObs.bind(to: totalTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.startDateDriver.drive(startDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.endDateDriver.drive(endDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.startTimeDriver.drive(startTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.endTimeDriver.drive(endTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        viewModel.startTimeSliderValueObs.subscribe(startTimeSlider.rx.value)
            .disposed(by: disposeBag)
        
        viewModel.endTimeSliderValueObs.subscribe(endTimeSlider.rx.value)
            .disposed(by: disposeBag)
        
        
        viewModel.startLabelObs.subscribe(with: self) { owner, isHidden in
            owner.startDateLabel.isHidden = isHidden
            owner.startTimeLabel.isHidden = isHidden
            owner.showStartDateLabel.isHidden = !isHidden
        }.disposed(by: disposeBag)
        
        viewModel.endLabelObs.subscribe(with: self) { owner, isHidden in
            owner.endDateLabel.isHidden = isHidden
            owner.endTimeLabel.isHidden = isHidden
            owner.showEndDateLabel.isHidden = !isHidden
        }.disposed(by: disposeBag)
        
        viewModel.selectDateObs.subscribe(with: self) { owner, date in
            owner.calendar.selectedDates.forEach({owner.calendar.deselect($0)})
            owner.calendar.select(date.date)
            owner.calendar.reloadData()
        }.disposed(by: disposeBag)
        
        
        // MARK: 開始的時間
        
        viewModel.startTimeDriver.drive(startTimeSlider.thumbTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        startTimeSlider.rx.controlEvent(.valueChanged).subscribe(with: self) { owner, _ in
            // round the slider position to the nearest index of the numbers array
            let index = Int(owner.startTimeSlider.value + 0.5)
            if owner.viewModel.isStartSliderLess(than: index) {
                owner.startTimeSlider.setValue(owner.viewModel.minStartSliderTimeValue, animated: false)
            }else if owner.viewModel.isStartSliderMore(than: index) {
                owner.startTimeSlider.setValue(owner.viewModel.maxStartSliderTimeValue, animated: false)
            }else {
                if owner.oldIndex != index {
//                    owner.startTimeSlider.setValue(Float(index), animated: false)
                    owner.viewModel.timeSliderDidChange(index, .start)
                    Tools.vibrationStart(.soft)
                    owner.oldIndex = index
                }
            }
        }.disposed(by: disposeBag)
        
        // MARK: 結束的時間
        viewModel.endTimeDriver.drive(endTimeSlider.thumbTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        endTimeSlider.rx.controlEvent(.valueChanged).subscribe(with: self) { owner, _ in
            // round the slider position to the nearest index of the numbers array
            let index = Int(owner.endTimeSlider.value + 0.5)
            if owner.viewModel.isEndSliderLess(index, .end) {
                owner.endTimeSlider.setValue(owner.viewModel.minEndSliderTimeValue, animated: false)
            }else {
                if owner.oldIndex != index {
//                    owner.endTimeSlider.setValue(Float(index), animated: false)
                    owner.viewModel.timeSliderDidChange(index, .end)
                    Tools.vibrationStart(.soft)
                    owner.oldIndex = index
                }
            }
        }.disposed(by: disposeBag)
        
    }
    
    func uiSetup() {
        calendar.select(viewModel.startDate.date, scrollToDate: true)
        calendar.select(viewModel.endDate.date, scrollToDate: true)
//        viewModel.startDate = FSCalendarManager.shared.startDate
//        viewModel.endDate = FSCalendarManager.shared.endDate
        
        dateArrowImg.image = .dateArrow.withRenderingMode(.alwaysOriginal).withTintColor(.label)
    }
    
    // MARK: - Slider Setup
    func sliderSetup() {
        
        // slider values go from 0 to the number of values in your numbers array
        startTimeSlider.maximumValue = 47;
        startTimeSlider.minimumValue = 0
        startTimeSlider.minimumTrackTintColor = .systemFill
        startTimeSlider.maximumTrackTintColor = .customBlue
        
        startTimeSlider.setValue(viewModel.startSliderTimeValue, animated: true)
        
        // slider values go from 0 to the number of values in your numbers array
        endTimeSlider.maximumValue = 47;
        endTimeSlider.minimumValue = 0
        endTimeSlider.minimumTrackTintColor = .customBlue
        
        endTimeSlider.setValue(viewModel.endSliderTimeValue, animated: true)
    }
    
    private func setLabelHidden(_ hidden: Bool, animated: Bool) {
        let animations = {
            //            self.label.alpha = hidden ? 0 : 1
        }
        if animated {
            UIView.animate(withDuration: 0.11, animations: animations)
        } else {
            animations()
        }
    }
    
    func setupCalendar() {
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.pagingEnabled = false
        calendar.today = nil //Hide the today circle
        calendar.placeholderType = .none
        //        calendar.weekdayHeight = 0
        calendar.locale = Locale(identifier: "zh-Hant-TW")
        calendar.firstWeekday = 1 // 禮拜日為頭
        
        calendar.appearance.caseOptions = .weekdayUsesSingleUpperCase // 只weekday顯示一個字
        
        calendar.appearance.selectionColor = .customBlue
        
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
        calendar.appearance.headerDateFormat = "YYYY年MM月"
        
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleFont = .systemFont(ofSize: 17)
        calendar.appearance.titleOffset.y = 4.5
        
        calendar.appearance.weekdayTextColor = .secondaryLabel
        calendar.appearance.headerSeparatorColor = .clear // Hidden Header Line
        
        //        calendar.clipsToBounds = false // Remove top/bottom line
        
        calendar.rowHeight = 50
        
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        calendar.scrollDirection = .vertical
        
        calendar.register(DateCalendarCell.self, forCellReuseIdentifier: "DateCalendarCell")
        
    }
    
    // MARK: - Action
    @IBAction func saveBtnPressed(_ sender: PressEffectBtn) {
        JayCalendarManager.shared.saveStartAndEnd(viewModel.startDate, viewModel.startTime, viewModel.endDate, viewModel.endTime)
        self.dismiss(animated: true)
    }
    
    
}


extension JayCalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        return .clear
    }
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date().dateByAdding(30, .minute).date
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().addingTimeInterval((24*60*60)*365)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        print("Date Selected : \(formatter.string(from: date))")
        print("Date Selected ** \(date.easyToFormat("EE, MM/dd"))")
        //        print("Date Selected == \(date.toISO(.withFullDate)))")
        // 如果是從should Deselect 進來的話，count要加1
        viewModel.calendarDidselect(date.easyConvertToTaipeiZone, false, calendar.selectedDates.count)
        
        configureVisibleCells()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        return true
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // 如果是從should Deselect 進來的話，count要加1
        viewModel.calendarDidselect(date.easyConvertToTaipeiZone, true, calendar.selectedDates.count+1)
        configureVisibleCells()
        
        return false
    }
    
    // ---------------------------------------------
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "DateCalendarCell", for: date, at: position)
        cell.contentView.backgroundColor = .systemBackground
        
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    
    // MARK: - FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        
    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        //        guard date > calendar.minimumDate && date < calendar.maximumDate else { return }
        guard let diyCell = (cell as? DateCalendarCell) else {return}
        //        diyCell.circleImageView.isHidden = true
        if position == .current {
            var selectionType = SelectionType.none
            if calendar.selectedDates.count == 2 {
                var first = calendar.selectedDates[0]
                var second = calendar.selectedDates[1]
                if second <= first {
                    let temp = first
                    first = second
                    second = temp
                }
                if date == first {
                    selectionType = .leftBorder_circle
                } else if date == second {
                    selectionType = .rightBorder_circle
                } else if date >= first && date <= second {
                    selectionType = .middle
                }
            } else {
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.count == 1 {
                        if viewModel.isSameDayClickTwice {
                            selectionType = .twoInOne
                        }else {
                            selectionType = .single
                        }
                    } else {
                        selectionType = .none
                    }
                } else {
                    selectionType = .none
                }
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
        } else {
            diyCell.selectionLayer.isHidden = true
            //            diyCell.titleLabel.textColor = .label
        }
    }
    
}




