//
//  InfoNowUITests.swift
//  InfoNowUITests
//
//  Created by Stefan kund on 12/10/2025.
//

import XCTest


final class InfoNowUITests: XCTestCase {
    enum MocButtons {
        case succes, empty, error1, error2
    }
    let app = XCUIApplication()
    let springBoard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    
    private func openMockMenuAndSelect(moc: MocButtons) {
        app.doubleTap()

        let moc_succes_button = app.buttons["Moc: succes"]
        let moc_empty_button = app.buttons["Moc: empty responce"]
        let moc_unauthorized_request_button = app.buttons["Moc: unauthorized request"]
        let moc_server_error_button = app.buttons["Moc: server error"]
        
        XCTAssertTrue(moc_succes_button.waitForExistence(timeout: 1), "Moc menu '\(moc_succes_button)' wasn't found")
        XCTAssertTrue(moc_empty_button.waitForExistence(timeout: 1), "Main View '\(moc_empty_button)' wasn't found")
        XCTAssertTrue(moc_unauthorized_request_button.waitForExistence(timeout: 1), "Main View '\(moc_unauthorized_request_button)' wasn't found")
        XCTAssertTrue(moc_server_error_button.waitForExistence(timeout: 1), "Main View '\(moc_server_error_button)' wasn't found")
        
        switch moc {
        case .succes:
            moc_succes_button.tap()
        case .empty:
            moc_empty_button.tap()
        case .error1:
            moc_unauthorized_request_button.tap()
        case .error2:
            moc_server_error_button.tap()
        }
    }

    private func prepareForInterface() {
        if self.app.state != .notRunning {
            app.terminate()
        }
        app.launch()
    }

    override func setUpWithError() throws {
        continueAfterFailure = true
        
        self.prepareForInterface()
    }

    override func tearDownWithError() throws {
        
    }

    func test_001_mainView_Success_Loaded_All_VisualItems() throws {
        let mainMenuButton = app.buttons["button_menu"]
        let titleText = app.staticTexts["text_titre"]
        let newsCountText = app.staticTexts["text_nbOfNews"]
        
        let title_00 = "Toute l’actualité en français"
        let title_01 = "Titres à la une"
        let title_02 = "Rechercher"
        
        // 00 Verify that title and news count text views are present
        XCTAssertTrue(titleText.waitForExistence(timeout: 1), "Main View title text view wasn't found")
        XCTAssertTrue(newsCountText.exists, "Main View news count text view wasn't found")
        XCTAssertTrue(app.staticTexts[title_00].exists, "Main View text '\(title_00)' wasn't found")
        
        // 01 Verify menu button and menu items
        XCTAssertTrue(mainMenuButton.waitForExistence(timeout: 1), "Main View menu button wasn't found")
        
        mainMenuButton.tap()
        
        let menuButtonItem_00 = app.buttons["menu_item_00"]
        let menuButtonItem_01 = app.buttons["menu_item_01"]
        let menuButtonItem_02 = app.buttons["menu_item_02"]
        
        // Verify that all menu buttons are present
        XCTAssertTrue(menuButtonItem_00.waitForExistence(timeout: 1), "Main View menu item '00' wasn't found")
        XCTAssertTrue(menuButtonItem_01.exists, "Main View menu item '01' wasn't found")
        XCTAssertTrue(menuButtonItem_02.exists, "Main View menu item '02' wasn't found")
        
        // Verify that menu buttons display the correct titles
        XCTAssertTrue(app.buttons[title_00].exists, "Main View button '\(title_00)' wasn't found")
        XCTAssertTrue(app.buttons[title_01].exists, "Main View button '\(title_01)' wasn't found")
        XCTAssertTrue(app.buttons[title_02].exists, "Main View button '\(title_02)' wasn't found")
        
        // 02 Verify that main view title updates to 'Titres à la une' after selecting the corresponding menu item
        menuButtonItem_01.tap()
        XCTAssertTrue(app.staticTexts[title_01].exists, "Main View text '\(title_01)' wasn't found")
        XCTAssertTrue(newsCountText.exists, "Main View news count text view wasn't found")
        
        // 03 Verify that all UI elements in the search state are present
        mainMenuButton.tap()
        menuButtonItem_02.tap()
        
        XCTAssertTrue(app.images["image_search"].exists, "Main View search image wasn't found")
        
        let searchTextField = app.textFields["textField_search"]
        XCTAssertTrue(searchTextField.exists, "Main View search text field wasn't found")
        
        let clearSearchTextButton = app.buttons["clear_search_text"]
        XCTAssertFalse(clearSearchTextButton.exists, "Main View clear search text button is present but shouldn't be")
        
        searchTextField.tap()
        searchTextField.typeText("iOS")
        
        // Verify that the clear search button appears after typing
        XCTAssertTrue(clearSearchTextButton.exists, "Main View clear search text button wasn't found after typing")
    }
    
    func test_002_mainView_Success_display_all_view_states() throws {
        self.openMockMenuAndSelect(moc: .succes)
        
        let retryButton = app.buttons["Essayez à nouveau"]
        let newsCountText100 = app.staticTexts["100 article(s)"]
        
        // Verify that the main view displays 100 articles and the retry button is not visible
        XCTAssertTrue(newsCountText100.exists, "Main View text '100 article(s)' wasn't found")
        XCTAssertFalse(retryButton.exists, "Main View retry button was found but shouldn't be")
        
        self.openMockMenuAndSelect(moc: .empty)
        
        let newsCountText0 = app.staticTexts["0 article(s)"]
        let emptyStateMessage = app.staticTexts["Oups… il n’y a pas d’articles pour le moment !"]
        
        // Verify the empty state: 0 articles + empty message + retry button visible
        XCTAssertTrue(newsCountText0.exists, "Main View text '0 article(s)' wasn't found")
        XCTAssertTrue(emptyStateMessage.exists, "Main View empty state message wasn't found")
        XCTAssertTrue(retryButton.exists, "Main View retry button wasn't found")
        
        self.openMockMenuAndSelect(moc: .error1)
        
        let errorMessage01 = app.staticTexts["Une erreur est survenue lors du chargement des articles."]
        
        // Verify error state 1: error message and retry button visible
        XCTAssertTrue(errorMessage01.exists, "Main View error message 01 wasn't found")
        XCTAssertTrue(retryButton.exists, "Main View retry button wasn't found")
        
        self.openMockMenuAndSelect(moc: .error2)
        
        // Verify error state 2: same error message and retry button visible
        XCTAssertTrue(errorMessage01.exists, "Main View error message 01 wasn't found")
        XCTAssertTrue(retryButton.exists, "Main View retry button wasn't found")
    }

    func test_003_open_detail_news_view() throws {
        self.openMockMenuAndSelect(moc: .succes)
        
        let firstNewsCell = app.staticTexts["Lola Young porte plainte contre le producteur de son tube « Messy »"].firstMatch
        
        // Verify that the first news cell is visible
        XCTAssertTrue(firstNewsCell.waitForExistence(timeout: 1), "Main View first news cell wasn't found")
        firstNewsCell.tap()
        
        let closeButton = app.buttons["close_button"]
        
        // Verify that the close button in the detail view is visible
        XCTAssertTrue(closeButton.waitForExistence(timeout: 1), "Detail View close button wasn't found")
        
        // Verify that the main texts are visible in the detail view
        XCTAssertTrue(app.staticTexts["Par 20 Minutes avec agences"].waitForExistence(timeout: 1), "Detail View text 'Par 20 Minutes avec agences' wasn't found")
        XCTAssertTrue(app.staticTexts["Lola Young porte plainte contre le producteur de son tube « Messy »"].exists, "Detail View title text wasn't found")
        XCTAssertTrue(app.staticTexts["Le producteur revendiquerait indûment les crédits d’écriture de quatre des titres de la chanteuse britannique"].exists, "Detail View description text wasn't found")
        
        let urlLinkButton = app.buttons["urlLink_button"]
        
        // Verify that the external URL link button is visible
        XCTAssertTrue(urlLinkButton.exists, "Detail View 'URL link' button wasn't found")
    }

}
