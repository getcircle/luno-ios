//
//  ClientTests.swift
//  Circle
//
//  Created by Michael Hahn on 12/19/14.
//  Copyright (c) 2014 RH Labs Inc. All rights reserved.
//

import UIKit
import XCTest
import Circle
import ProtobufRegistry

class ClientTests: XCTestCase {
    
    var client: ServiceClient!

    override func setUp() {
        super.setUp()
        self.client = ServiceClient(serviceName: "user")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testClientCallAction() {
        let requestBuilder = UserService.AuthenticateUser.Request.builder()
        requestBuilder.backend = UserService.AuthenticateUser.Request.AuthBackend.Internal
        
        let credentialsBuilder = requestBuilder.credentials.builder()
        credentialsBuilder.key = "mwhahn@gmail.com"
        credentialsBuilder.secret = "rh123"
        requestBuilder.credentials = credentialsBuilder.build()
        
        let expectation = expectationWithDescription("authenticate_user action")
        client.callAction("authenticate_user", extensionField: UserServiceRequests_authenticate_user, request: requestBuilder.build()) {
            (request, response, serviceResponse, actionResponse, error) in
            expectation.fulfill()
            
            XCTAssertNil(error, "Should not have resulted in an error")
            XCTAssertTrue(actionResponse?.result.success != nil, "Action should have been successful")
            
            let actionExtension = actionResponse!.result.getExtension(UserServiceResponses_authenticate_user) as UserService.AuthenticateUser.Response
            let user = actionExtension.user
            
            XCTAssertEqual(user.primary_email, "mwhahn@gmail.com", "Should have the correct email address")
            XCTAssertEqual(user.identities.count, 1, "Should have 1 identity associated with the user")
            
            let identity = user.identities[0]
            XCTAssertEqual(identity.user_id, user.id, "Identity should have the same user_id")
            XCTAssertEqual(identity.first_name, "Michael", "Identity should have the correct first name")
            XCTAssertEqual(identity.last_name, "Hahn", "Identity should have the correct last name")
            XCTAssertEqual(identity.email, user.primary_email, "Identity should have the same email as the primary email address")
            XCTAssertEqual(identity.type, Identity.Types.Internal, "Identity should be an internal identity")
        }
        
        waitForExpectationsWithTimeout(3, handler: nil)
    }
}
