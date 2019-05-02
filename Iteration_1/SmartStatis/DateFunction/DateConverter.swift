//
//  SettingTableViewController.swift
//  SmartStatis
//
//  Created by Jerry Tang on 2019/4/4.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This class is to create the object class for handling all the date requirement.
 */
class DateConverter: NSObject {
    /*
        This method is to convert date object into string object.
     */
    func dateConvertString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    /*
        This method is to calculate the number of days between two given days.
     */
    func numberOfDays (firstDate: Date,secondDate: Date) -> Int  {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: firstDate)
        let date2 = calendar.startOfDay(for: secondDate)
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    /*
        This method is to convert date object into string object.
     */
    func dateFormatter(dateString:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: dateString)
        return date!
    }
}

/*
    This extension is to establish the functions for easily dealing with date.
 */
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
