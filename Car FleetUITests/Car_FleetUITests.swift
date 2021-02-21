//
//  Car_FleetUITests.swift
//  Car FleetUITests
//
//  Created by Astha yadav on 23/01/21.
//

import XCTest

class Car_FleetUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCompleteFlow() {
        app.tables["tbl"].staticTexts["Audi"].tap()
        app.tables["table--modelTV"].staticTexts["100"].tap()
        app.alerts["Info"].scrollViews.otherElements.buttons["OK"].tap()
        app.navigationBars["Model"].buttons["Manufacturer"].tap()
       
     }
    
    
}
