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

let TEST_TIMEOUT: NSTimeInterval = 3

class ClientTests: XCTestCase {
    
    var client: ServiceClient!

    override func setUp() {
        super.setUp()
        self.client = ServiceClient(serviceName: "user", token: nil)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testClientCallAuthExemptAction() {
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
            
            XCTAssertTrue(actionExtension.token != "", "Token should have been returned for the user")
            XCTAssertEqual(user.primary_email, "mwhahn@gmail.com", "Should have the correct email address")
            XCTAssertEqual(user.identities.count, 1, "Should have 1 identity associated with the user")
            
            let identity = user.identities[0]
            XCTAssertEqual(identity.user_id, user.id, "Identity should have the same user_id")
            XCTAssertEqual(identity.first_name, "Michael", "Identity should have the correct first name")
            XCTAssertEqual(identity.last_name, "Hahn", "Identity should have the correct last name")
            XCTAssertEqual(identity.email, user.primary_email, "Identity should have the same email as the primary email address")
            XCTAssertEqual(identity.type, Identity.Types.Internal, "Identity should be an internal identity")
        }
        
        waitForExpectationsWithTimeout(TEST_TIMEOUT, handler: nil)
    }
    
    func testClientCallActionNoAuthToken() {
        let requestBuilder = UserService.ValidUser.Request.builder()
        requestBuilder.user_id = "123456"
        
        let expectaton = expectationWithDescription("valid_user action")
        client.callAction("valid_user", extensionField: UserServiceRequests_valid_user, request: requestBuilder.build()) {
            (request, response, serviceResponse, actionResponse, error) in
            expectaton.fulfill()
            
            XCTAssertFalse(actionResponse!.result.success)
            XCTAssertTrue(actionResponse!.result.errors.count > 0, "We should have an authentication error")
            XCTAssertEqual(actionResponse!.result.errors[0], "FORBIDDEN", "We should have returned the FORBIDDEN error code")
        }
        waitForExpectationsWithTimeout(TEST_TIMEOUT, handler: nil)
    }
    
    func testClientCallActionTestAuthToken() {
        let requestBuilder = UserService.AuthenticateUser.Request.builder()
        requestBuilder.backend = UserService.AuthenticateUser.Request.AuthBackend.Internal
        
        let credentialsBuilder = requestBuilder.credentials.builder()
        credentialsBuilder.key = "mwhahn@gmail.com"
        credentialsBuilder.secret = "rh123"
        requestBuilder.credentials = credentialsBuilder.build()
        
        let expectation = expectationWithDescription("make second request with token")
        client.callAction("authenticate_user", extensionField: UserServiceRequests_authenticate_user, request: requestBuilder.build()) {
            (response, request, serviceResponse, actionResponse, error) -> Void in
            XCTAssertTrue(actionResponse!.result.success, "Authentication should have succeeded")
            let actionExtension = actionResponse!.result.getExtension(UserServiceResponses_authenticate_user) as UserService.AuthenticateUser.Response
            
            // call the second action and verify it works with the token we just got
            let requestBuilder = UserService.ValidUser.Request.builder()
            requestBuilder.user_id = actionExtension.user.id
            self.client.token = actionExtension.token
            self.client.callAction("valid_user", extensionField: UserServiceRequests_valid_user, request: requestBuilder.build(), completionHandler: {
                (response, request, serviceResponse, actionResponse, error) -> Void in
                expectation.fulfill()
                XCTAssertTrue(actionResponse!.result.success, "Action should have succeeded")
                
                let validUser = actionResponse!.result.getExtension(UserServiceResponses_valid_user) as UserService.ValidUser.Response
                XCTAssertTrue(validUser.exists, "User should exist")
            })
        }
        waitForExpectationsWithTimeout(TEST_TIMEOUT, handler: nil)
    }
    
}
