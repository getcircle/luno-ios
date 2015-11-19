//
//  TextDataTests.swift
//  Luno
//
//  Created by Ravi Rani on 10/19/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import XCTest
@testable import luno
import ProtobufRegistry

class TextDataTests: XCTestCase {
    
    let authorProfileName = "Ravi Rani"
    let placeholder = "Test Placeholder"
    
    var authorProfile: Services.Profile.Containers.ProfileV1?
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            authorProfile = try Services.Profile.Containers.ProfileV1.Builder().setFullName(authorProfileName).build()
        }
        catch {
            authorProfile = nil
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetFormattedTimestamp() {
        let dateFormatter = NSDateFormatter.sharedTimestampFormatter
        
        let nowTimestampString = dateFormatter.stringFromDate(NSDate())
        XCTAssertEqual(TextData.getFormattedTimestamp(nowTimestampString), " \u{2013} <1m ago")
        
        // 5 second correction is to ensure we don't hit second boundaries while the tests are executing
        let underAnHourTimestampString = dateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: -(60*30 + 5)))
        XCTAssertEqual(TextData.getFormattedTimestamp(underAnHourTimestampString), " \u{2013} 30m ago")

        let underADayTimestampString = dateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: -(60*60*8 + 5)))
        XCTAssertEqual(TextData.getFormattedTimestamp(underADayTimestampString), " \u{2013} 8h ago")

        let overADayTimestampString = dateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: -(60*60*60 + 5)))
        XCTAssertEqual(TextData.getFormattedTimestamp(overADayTimestampString), " \u{2013} 2d 12h ago")
        
        if let authorProfile = authorProfile {
            let nowTimestampString = dateFormatter.stringFromDate(NSDate())
            XCTAssertEqual(
                TextData.getFormattedTimestamp(nowTimestampString, authorProfile: authorProfile),
                " \u{2013} <1m ago by " + authorProfileName
            )

            let overADayTimestampString = dateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: -(60*60*60 + 5)))
            XCTAssertEqual(
                TextData.getFormattedTimestamp(overADayTimestampString, authorProfile: authorProfile),
                " \u{2013} 2d 12h ago by " + authorProfileName
            )
        }
    }
    
    func testGetEditablePlaceholder() {
        let textDataNilPlaceholder = TextData(type: .TeamDescription, andValue: "")
        XCTAssertNil(textDataNilPlaceholder.placeholder)
        
        let textDataWithPlaceholder = TextData(
            type: .TeamDescription,
            andValue: "",
            andPlaceholder: placeholder
        )
        XCTAssertNotNil(textDataWithPlaceholder.placeholder)
        XCTAssertEqual(textDataWithPlaceholder.placeholder, placeholder)
        
        let textDataEditableTeamDescription = TextData(
            type: .TeamDescription,
            andValue: "",
            andPlaceholder: placeholder,
            andCanEdit: true
        )
        XCTAssertEqual(
            textDataEditableTeamDescription.placeholder,
            AppStrings.AddTeamDescriptionPlaceholder
        )
        
        let textDataEditableTeamStatus = TextData(
            type: .TeamStatus,
            andValue: "",
            andPlaceholder: placeholder,
            andCanEdit: true
        )
        XCTAssertEqual(
            textDataEditableTeamStatus.placeholder,
            AppStrings.AddDetailsPlaceholder
        )
    }
}
