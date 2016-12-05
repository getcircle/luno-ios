//
//  NSDateExtensionTests.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-11.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import XCTest
@testable import luno

class NSDateExtensionTests: XCTestCase {
    
    // MARK: - Test cases
    
    func testFutureDate() {
        XCTAssertEqual("", NSDate(timeIntervalSinceNow: 60).timeAgo())
    }
    
    func testExactlyOneYearAgo() {
        XCTAssertEqual("1 year ago", pastDate(yearsAgo: 1).timeAgo())
    }
    
    func testExactlyMoreThanOneYearAgo() {
        XCTAssertEqual("2 years ago", pastDate(yearsAgo: 2).timeAgo())
    }
    
    func testLessThanThreeYearsAgoHasMonth() {
        XCTAssertEqual("2 years 1 month ago", pastDate(yearsAgo: 2, monthsAgo: 1).timeAgo())
    }
    
    func testMoreThanThreeYearsAgoNoMonths() {
        XCTAssertEqual("3 years ago", pastDate(yearsAgo: 3, monthsAgo: 6).timeAgo())
    }
    
    func testMonthAgo() {
        XCTAssertEqual("1 month ago", pastDate(monthsAgo: 1).timeAgo())
    }
    
    func testMonthsAgo() {
        XCTAssertEqual("11 months ago", pastDate(monthsAgo: 11).timeAgo())
    }
    
    func testDayAgo() {
        XCTAssertEqual("1 day ago", pastDate(daysAgo: 1).timeAgo())
    }
    
    func testDaysAgo() {
        XCTAssertEqual("6 days ago", pastDate(daysAgo: 6).timeAgo())
    }
    
    func testHourAgo() {
        XCTAssertEqual("1 hour ago", pastDate(hoursAgo: 1).timeAgo())
    }
    
    func testHoursAgo() {
        XCTAssertEqual("23 hours ago", pastDate(hoursAgo: 23).timeAgo())
    }
    
    func testMinuteAgo() {
        XCTAssertEqual("1 minute ago", pastDate(minutesAgo: 1).timeAgo())
    }
    
    func testMinutesAgo() {
        XCTAssertEqual("59 minutes ago", pastDate(minutesAgo: 59).timeAgo())
    }
    
    func testLessThanOneMinuteAgo() {
        XCTAssertEqual("less than 1 minute ago", NSDate().timeAgo())
    }
    
    func testNoAgo() {
        XCTAssertEqual("less than 1 minute", NSDate().timeAgo(addAgo: false))
    }
    
    // MARK: - Helpers
    
    private func pastDate(yearsAgo yearsAgo: Int = 0, monthsAgo: Int = 0, daysAgo: Int = 0, hoursAgo: Int = 0, minutesAgo: Int = 0) -> NSDate {
        var date = NSDate()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let newDate = calendar?.dateByAddingUnit(.Minute, value: -minutesAgo, toDate: date, options: []) {
            date = newDate
        }
        if let newDate = calendar?.dateByAddingUnit(.Hour, value: -hoursAgo, toDate: date, options: []) {
            date = newDate
        }
        if let newDate = calendar?.dateByAddingUnit(.Day, value: -daysAgo, toDate: date, options: []) {
            date = newDate
        }
        if let newDate = calendar?.dateByAddingUnit(.Month, value: -monthsAgo, toDate: date, options: []) {
            date = newDate
        }
        if let newDate = calendar?.dateByAddingUnit(.Year, value: -yearsAgo, toDate: date, options: []) {
            date = newDate
        }
        
        return date
    }
    
}

