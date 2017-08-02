//
//  ellactronTests.swift
//  ellactronTests
//
//  Created by admin on 2017-07-25.
//  Copyright © 2017 NewBeem. All rights reserved.
//

import XCTest
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
        let restClient = RestClient()
        
        do {
            try restClient.get(
                uri:"https://www.google.com",
                onCompletion: { (json: Any?, error: Error?) -> Void in
                    assert(nil == error)
            } )
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
