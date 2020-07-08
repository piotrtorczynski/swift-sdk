//
//  AuthTests.swift
//  swift-sdk-swift-tests
//
//  Created by Jay Kim on 7/6/20.
//  Copyright © 2020 Iterable. All rights reserved.
//

import XCTest

@testable import IterableSDK

class AuthTests: XCTestCase {
    private static let apiKey = "zeeApiKey"
    private static let email = "user@example.com"
    private static let userId = "testUserId"
    private static let authToken = "testAuthToken"
    
    override func setUp() {
        super.setUp()
        
        TestUtils.clearTestUserDefaults()
    }
    
    func testEmailPersistence() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        internalAPI.email = AuthTests.email
        
        XCTAssertEqual(internalAPI.email, AuthTests.email)
        XCTAssertNil(internalAPI.userId)
        XCTAssertNil(internalAPI.auth.authToken)
    }
    
    func testUserIdPersistence() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        internalAPI.userId = AuthTests.userId
        
        XCTAssertNil(internalAPI.email)
        XCTAssertEqual(internalAPI.userId, AuthTests.userId)
        XCTAssertNil(internalAPI.auth.authToken)
    }
    
    func testEmailWithTokenPersistence() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        internalAPI.email = "previous.user@example.com"
        
        let emailToken = "asdf"
        
        internalAPI.setEmail(AuthTests.email, withToken: emailToken)
        
        XCTAssertEqual(internalAPI.email, AuthTests.email)
        XCTAssertNil(internalAPI.userId)
        XCTAssertEqual(internalAPI.auth.authToken, emailToken)
    }
    
    func testUserIdWithTokenPersistence() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        internalAPI.userId = "previousUserId"
        
        let userIdToken = "qwer"
        
        internalAPI.setUserId(AuthTests.userId, withToken: userIdToken)
        
        XCTAssertNil(internalAPI.email)
        XCTAssertEqual(internalAPI.userId, AuthTests.userId)
        XCTAssertEqual(internalAPI.auth.authToken, userIdToken)
    }
    
    func testUserLoginAndLogout() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        internalAPI.setEmail(AuthTests.email)
        
        XCTAssertEqual(internalAPI.email, AuthTests.email)
        XCTAssertNil(internalAPI.userId)
        XCTAssertNil(internalAPI.auth.authToken)
        
        internalAPI.email = nil
        
        XCTAssertNil(internalAPI.email)
        XCTAssertNil(internalAPI.userId)
        XCTAssertNil(internalAPI.auth.authToken)
    }
    
    func testEmailWithTokenChange() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        let originalEmail = "first@example.com"
        let originalToken = "fdsa"
        
        let newEmail = "second@example.com"
        let newToken = "jay"
        
        internalAPI.setEmail(originalEmail, withToken: originalToken)
        
        XCTAssertEqual(internalAPI.email, originalEmail)
        XCTAssertNil(internalAPI.userId)
        XCTAssertEqual(internalAPI.auth.authToken, originalToken)
        
        internalAPI.setEmail(newEmail, withToken: newToken)
        
        XCTAssertEqual(internalAPI.email, newEmail)
        XCTAssertNil(internalAPI.userId)
        XCTAssertEqual(internalAPI.auth.authToken, newToken)
    }
    
    func testUpdateEmailWithToken() {
        let condition1 = expectation(description: "update email with auth token")
        
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        let originalEmail = "first@example.com"
        let originalToken = "fdsa"
        
        let updatedEmail = "second@example.com"
        let updatedToken = "jay"
        
        internalAPI.setEmail(originalEmail, withToken: originalToken)
        
        XCTAssertEqual(internalAPI.email, originalEmail)
        XCTAssertNil(internalAPI.userId)
        XCTAssertEqual(internalAPI.auth.authToken, originalToken)
        
        internalAPI.updateEmail(updatedEmail,
                                withToken: updatedToken,
                                onSuccess: { (data) in
                                    XCTAssertEqual(internalAPI.email, updatedEmail)
                                    XCTAssertNil(internalAPI.userId)
                                    XCTAssertEqual(internalAPI.auth.authToken, updatedToken)
                                    
                                    condition1.fulfill()
        },
                                onFailure: nil)
        
        wait(for: [condition1], timeout: testExpectationTimeout)
    }

    func testLogoutUser() {
        let internalAPI = IterableAPIInternal.initializeForTesting()
        
        internalAPI.setEmail(AuthTests.email, withToken: AuthTests.authToken)
        
        XCTAssertEqual(internalAPI.email, AuthTests.email)
        XCTAssertNil(internalAPI.userId)
        XCTAssertEqual(internalAPI.auth.authToken, AuthTests.authToken)
        
        internalAPI.logoutUser()
        
        XCTAssertNil(internalAPI.email)
        XCTAssertNil(internalAPI.userId)
        XCTAssertNil(internalAPI.auth.authToken)
    }
}
