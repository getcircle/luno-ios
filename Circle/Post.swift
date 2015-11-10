//
//  Post.swift
//  Luno
//
//  Created by Felix Mo on 2015-11-10.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import Foundation
import ProtobufRegistry

extension Services.Post.Containers.PostV1 {

    func getFormattedChangedDate() -> String? {
        if changed.trimWhitespace() != "" {
            if let changedDate = NSDateFormatter.dateFromTimestampString(changed) {
                
                var formattedChangedDate = [String]()
                
                let today = NSDate()
                if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
                    let unitFlags = [.Day, .Year, .Month, .Hour, .Minute] as NSCalendarUnit
                    let diffComponents = calendar.components(
                        unitFlags,
                        fromDate: changedDate,
                        toDate: today,
                        options: []
                    )
                    
                    if diffComponents.year == 1 {
                        formattedChangedDate.append(
                            NSLocalizedString("1 year", comment: "String indicating duration of 1 year")
                        )
                    }
                    else if diffComponents.year > 1 {
                        formattedChangedDate.append(NSString(
                            format: NSLocalizedString("%d years", comment: "String indicating duration of %d years"),
                            diffComponents.year
                            ) as String
                        )
                    }
                    
                    if diffComponents.month > 0 {
                        if diffComponents.month == 1 {
                            formattedChangedDate.append(
                                NSLocalizedString("1 month", comment: "String indicating duration of 1 month")
                            )
                        }
                        else if diffComponents.month < 12 {
                            formattedChangedDate.append(NSString(
                                format: NSLocalizedString("%d months", comment: "String indicating duration of %d months"),
                                diffComponents.month
                                ) as String
                            )
                        }
                    }
                    
                    if diffComponents.month == 0 && diffComponents.year == 0 {
                        if diffComponents.day < 7 {
                            // Less than one week
                            
                            if diffComponents.day == 1 {
                                formattedChangedDate.append(
                                    NSLocalizedString("1 day", comment: "String indicating duration of 1 day")
                                )
                            }
                            else if diffComponents.day > 1 {
                                formattedChangedDate.append(NSString(
                                    format: NSLocalizedString("%d days", comment: "String indicating duration of %d days"),
                                    diffComponents.day
                                    ) as String
                                )
                            }
                            else {
                                // Less than one day
                                
                                if diffComponents.hour == 1 {
                                    formattedChangedDate.append(
                                        NSLocalizedString("1 hour", comment: "String indicating duration of 1 hour")
                                    )
                                }
                                else if diffComponents.hour > 1 {
                                    formattedChangedDate.append(NSString(
                                        format: NSLocalizedString("%d hours", comment: "String indicating duration of %d hours"),
                                        diffComponents.hour
                                        ) as String
                                    )
                                }
                                else {
                                    // Less than one hour
                                    
                                    if diffComponents.minute == 1 {
                                        formattedChangedDate.append(
                                            NSLocalizedString("1 minute", comment: "String indicating duration of 1 minute")
                                        )
                                    }
                                    else if diffComponents.minute > 1 {
                                        formattedChangedDate.append(NSString(
                                            format: NSLocalizedString("%d minutes", comment: "String indicating duration of %d minutes"),
                                            diffComponents.minute
                                            ) as String
                                        )
                                    }
                                }
                                
                                if diffComponents.hour == 0 && diffComponents.minute == 0 {
                                    formattedChangedDate.append(
                                        NSLocalizedString("less than 1 minute", comment: "String indicating duration of less than 1 minute")
                                    )
                                }
                            }
                        }
                        else if diffComponents.day / 7 == 1 {
                            formattedChangedDate.append(
                                NSLocalizedString("1 week", comment: "String indicating duration of 1 week")
                            )
                        }
                        else {
                            formattedChangedDate.append(NSString(
                                format: NSLocalizedString("%d weeks", comment: "String indicating duration of %d weeks"),
                                diffComponents.day / 7
                                ) as String
                            )
                        }
                    }
                    
                    formattedChangedDate.append("ago")
                    
                    return formattedChangedDate.joinWithSeparator(" ")
                }
            }
        }
        
        return nil
    }

}