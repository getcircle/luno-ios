//
//  NSDateExtension.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-11.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import Foundation

extension NSDate {
    
    func timeAgo(addAgo addAgo: Bool = true) -> String {
        var timeAgoString = [String]()
        
        let today = NSDate()
        if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) where self.earlierDate(today) == self {
            let unitFlags = [.Day, .Year, .Month, .Hour, .Minute] as NSCalendarUnit
            let diffComponents = calendar.components(
                unitFlags,
                fromDate: self,
                toDate: today,
                options: []
            )
            
            if diffComponents.year == 1 {
                timeAgoString.append(
                    NSLocalizedString("1 year", comment: "String indicating duration of 1 year")
                )
            }
            else if diffComponents.year > 1 {
                timeAgoString.append(NSString(
                    format: NSLocalizedString("%d years", comment: "String indicating duration of %d years"),
                    diffComponents.year
                    ) as String
                )
            }
            
            // Show months between 1 to 3 years
            if diffComponents.year < 3 && diffComponents.month > 0 {
                if diffComponents.month == 1 {
                    timeAgoString.append(
                        NSLocalizedString("1 month", comment: "String indicating duration of 1 month")
                    )
                }
                else if diffComponents.month < 12 {
                    timeAgoString.append(NSString(
                        format: NSLocalizedString("%d months", comment: "String indicating duration of %d months"),
                        diffComponents.month
                        ) as String
                    )
                }
            }
            
            if diffComponents.month == 0 && diffComponents.year == 0 {
                if diffComponents.day < 7 {
                    // < 1 week
                    if diffComponents.day == 1 {
                        timeAgoString.append(
                            NSLocalizedString("1 day", comment: "String indicating duration of 1 day")
                        )
                    }
                    else if diffComponents.day > 1 {
                        timeAgoString.append(NSString(
                            format: NSLocalizedString("%d days", comment: "String indicating duration of %d days"),
                            diffComponents.day
                            ) as String
                        )
                    }
                    else {
                        // < 1 day
                        if diffComponents.hour == 1 {
                            timeAgoString.append(
                                NSLocalizedString("1 hour", comment: "String indicating duration of 1 hour")
                            )
                        }
                        else if diffComponents.hour > 1 {
                            timeAgoString.append(NSString(
                                format: NSLocalizedString("%d hours", comment: "String indicating duration of %d hours"),
                                diffComponents.hour
                                ) as String
                            )
                        }
                        else {
                            // < 1 hour
                            if diffComponents.minute == 1 {
                                timeAgoString.append(
                                    NSLocalizedString("1 minute", comment: "String indicating duration of 1 minute")
                                )
                            }
                            else if diffComponents.minute > 1 {
                                timeAgoString.append(NSString(
                                    format: NSLocalizedString("%d minutes", comment: "String indicating duration of %d minutes"),
                                    diffComponents.minute
                                    ) as String
                                )
                            }
                            else {
                                timeAgoString.append(
                                    NSLocalizedString("less than 1 minute", comment: "String indicating duration of less than 1 minute")
                                )
                            }
                        }
                    }
                }
                else if diffComponents.day / 7 == 1 {
                    timeAgoString.append(
                        NSLocalizedString("1 week", comment: "String indicating duration of 1 week")
                    )
                }
                else {
                    timeAgoString.append(NSString(
                        format: NSLocalizedString("%d weeks", comment: "String indicating duration of %d weeks"),
                        diffComponents.day / 7
                        ) as String
                    )
                }
            }
            
            if addAgo {
                timeAgoString.append("ago")
            }
        }
        return timeAgoString.joinWithSeparator(" ")
    }
    
}
