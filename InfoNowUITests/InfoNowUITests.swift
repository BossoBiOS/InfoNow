//
//  InfoNowUITests.swift
//  InfoNowUITests
//
//  Created by Stefan kund on 12/10/2025.
//

import XCTest

final class InfoNowUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    private func openMockMenu() {
        app.tap()
        app.doubleTap()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        
    }

    @MainActor
    func testMainPage_SuccesLoaded() async throws {
        
        XCTAssertTrue(app.staticTexts["Toute l’actualité en français"].exists)
        openMockMenu()
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
