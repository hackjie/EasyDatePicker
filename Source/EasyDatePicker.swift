//
//  AppDelegate.swift
//  EasyDatePicker
//
//  Created by 李杰 on 2019/3/11.
//  Copyright © 2019 李杰. All rights reserved.
//

import UIKit

let DatePickerCell_Height: CGFloat = 40.0

class EasyDatePicker: UIView {
    lazy var datePicker: UIPickerView = {
        let datePicker = UIPickerView()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.dataSource = self
        datePicker.delegate = self
        return datePicker
    }()
    
    lazy var showSelectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var selectYearIndex: Int = 0
    var selectMonthIndex: Int = 0
    var selectDayIndex: Int = 0
    
    /// 代表今天，不要变更这三个值
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var currentDay: Int = 0
    
    var years = [Int]()
    var months = [Int]()
    var days = [Int]()
    var dateStr: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(datePicker)
        let topConstraint = NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: datePicker, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: datePicker, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
        
        currentYear = Date().year()
        currentMonth = Date().month()
        currentDay = Date().day()
        
        years = getYears()
        months = getMonthsOfYear(currentYear)
        days = getDaysOfYear(currentYear, and: currentMonth)
        
        // default select rows
        datePicker.selectRow(selectYearIndex, inComponent: 0, animated: true)
        datePicker.selectRow(selectMonthIndex, inComponent: 0, animated: true)
        datePicker.selectRow(selectDayIndex, inComponent: 0, animated: true)
        
        dateStr = "\(years[selectYearIndex])"
            + "-\(months[selectMonthIndex])"
            + "-\(days[selectDayIndex])"
        
        clearSeparatorLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EasyDatePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.years.count
        case 1:
            return self.months.count
        case 2:
            return self.days.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return DatePickerCell_Height
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return (self.bounds.size.width - 56.0 - 50)/3.0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(self.years[row])
        case 1:
            return String(self.years[row])
        case 2:
            return String(self.years[row])
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor.black
        switch component {
        case 0:
            label.text = "\(self.years[row])"
            return label
        case 1:
            let monthIntValue = self.months[row]
            if monthIntValue < 10 {
                label.text = "0\(self.months[row])"
            } else {
                label.text = "\(self.months[row])"
            }
            return label
        case 2:
            label.text = "\(self.days[row])"
            return label
        default:
            return label
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if component == 0 {
            /// 记录当前选中的年份
            let year = years[row]
            selectYearIndex = row
            
            // 前
            let notChangedMonth = months[selectMonthIndex]
            let notChangedDay = days[selectDayIndex]
            
            // 后
            months = getMonthsOfYear(year)
            days = getDaysOfYear(year, and: notChangedMonth)
            
            if months.contains(notChangedMonth) {
                selectMonthIndex = months.index { $0 == notChangedMonth } ?? 0
            } else {
                selectMonthIndex = 0
            }
            
            if days.contains(notChangedDay) {
                selectDayIndex = days.index { $0 == notChangedDay } ?? 0
            } else {
                selectDayIndex = 0
            }
        } else if component == 1 {
            let year = years[selectYearIndex]
            let month = months[row]
            selectMonthIndex = row
            
            let notChangedDay = days[selectDayIndex]
            
            days = getDaysOfYear(year, and: month)
            
            if days.contains(notChangedDay) {
                selectDayIndex = days.index { $0 == notChangedDay } ?? 0
            } else {
                if notChangedDay <= self.currentDay {
                    selectDayIndex = 0
                } else {
                    selectDayIndex = days.count - 1
                }
            }
        } else if component == 2 {
            selectDayIndex = row
        }
        pickerView.reloadAllComponents()
        pickerView.selectRow(selectYearIndex, inComponent: 0, animated: false)
        pickerView.selectRow(selectMonthIndex, inComponent: 1, animated: false)
        pickerView.selectRow(selectDayIndex, inComponent: 2, animated: false)
        
        dateStr = "\(years[selectYearIndex])"
            + "-\(months[selectMonthIndex])"
            + "-\(days[selectDayIndex])"
        
    }
}

extension EasyDatePicker {
    func getYears() -> [Int] {
        let currentYear: Int = Date().year()
        let nextYear: Int = currentYear + 1
        return [currentYear, nextYear]
    }
    
    func getMonthsOfYear(_ year: Int) -> [Int] {
        if year == currentYear {
            return (currentMonth...12).map { $0 }
        } else {
            return (1...12).map { $0 }
        }
    }
    
    func getDaysOfYear(_ year:Int, and month: Int) -> [Int] {
        let num = Date().getCountOfDaysInMonth(year: year, month: month)
        if year == self.currentYear, month <= self.currentMonth {
            return (self.currentDay...num).map { return $0 }
        } else {
            let days = (1...num).map { return $0 }
            return days
        }
    }
}

extension EasyDatePicker {
    // remove separator line
    func clearSeparatorLine() {
        for subView in self.subviews {
            if subView.frame.size.height < 1 {
                subView.isHidden = true
            }
        }
    }
}
