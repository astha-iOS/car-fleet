//
//  Car_FleetTests.swift
//  Car FleetTests
//
//  Created by Astha yadav on 23/01/21.
//

import XCTest

@testable import Car_Fleet

class Car_FleetTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testManufacturer(){
        
        let item = CarManufacturer.init(id: "0555", title: "New Car")
        
        sortedCarManufacturer.append(item)
        
    }

}
