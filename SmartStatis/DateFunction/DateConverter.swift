//
//  DateConverter.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/2.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to manage the logic for transformation of date form.
 */
class DateConverter: NSObject {
    /*
        Method is to convert date into string.
     */
    func dateConvertString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    /*
        Method is to count the number of days between given two dates..
     */
    func numberOfDays (firstDate: Date,secondDate: Date) -> Int  {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        var days = components.day!
        if days >= 0 {
            days = days + 1
        }
        return days
    }
    
    /*
        Method is to convert string into date object.
     */
    func dateFormatter(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    /*
        Method is to convert string into data object with given rule.
     */
    func dateFormatterWithRule(dateString:String,rule:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = rule
        let date = dateFormatter.date(from: dateString)
        return date!
    }
}

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
