//
//  ellactronTests.swift
//  ellactronTests
//
//  Created by admin on 2017-07-25.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import XCTest
import Alamofire
@testable import ellactron

class ellactronTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadPropertiesFromPlist() {
        assert("www.ellactron.com" == ApplicationConfiguration.getServiceHostname()!)
    }
    
    
    func testHttpGetRequest() {
        let group = DispatchGroup()
        group.enter()
        
        let secureHttpClient = SecureHttpClient()
        do {
            try secureHttpClient.request(
                method: "get",
                uri:"https://www.ellactron.com:8443/login",
                onCompletion: { (responseString: String?) -> Void in
                    print("responseString = \(responseString!)") },
                errorHandler: { (error: String) -> Void in
                    print("error = \(error)")
            } )
        }
        catch {
            print("Invalid url exception")
        }
    }

    func testSecureURLProtocol() {
        let restClient = RestClient()
        do {
            try restClient.request(
            method: "get",
            url:"https://www.ellactron.com:8443/login",
            onCompletion: { (responseString: String?) -> Void in
                print("responseString = \(responseString!)") },
            errorHandler: { (error: String) -> Void in
                print("error = \(error)")} )
        }
        catch {
            print("Invalid url exception")
        }
    }

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
