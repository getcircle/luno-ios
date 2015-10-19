//
//  StringExtensionTests.swift
//  Luno
//
//  Created by Ravi Rani on 10/19/15.
//  Copyright © 2015 Luno Inc. All rights reserved.
//

import XCTest
@testable import luno

class StringExtensionTests: XCTestCase {
    
    func testSubscript() {
        let testString = "luno"
        XCTAssertEqual("l", testString[0])
        XCTAssertEqual("uno", testString[1..<(testString.characters.count)])
    }
    
    func testToDate() {
        XCTAssertNotNil("2015-10-10".toDate())
        XCTAssertNil("-10-10".toDate())
        XCTAssertNil("20-14-10".toDate())
        XCTAssertNil("".toDate())
    }
    
    func testTrimWhitespace() {
        XCTAssertEqual(" luno    ".trimWhitespace(), "luno")
    }
    
    func testRemovePhoneNumberFormatting() {
        XCTAssertEqual("(213) 321-0100".removePhoneNumberFormatting(), "2133210100")
        XCTAssertEqual("213-321-0100".removePhoneNumberFormatting(), "2133210100")
        XCTAssertEqual("2133210100".removePhoneNumberFormatting(), "2133210100")
        XCTAssertEqual("(213) (321)-0100".removePhoneNumberFormatting(), "2133210100")
        XCTAssertEqual("+(213) 321-0100".removePhoneNumberFormatting(), "+2133210100")
    }
    
    func testLocalizedUppercaseString() {
        XCTAssertEqual("luno".localizedUppercaseString(), "LUNO")
    }
}
