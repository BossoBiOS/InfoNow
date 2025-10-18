//
//  InfoNowTests.swift
//  InfoNowTests
//
//  Created by Stefan kund on 12/10/2025.
//

import XCTest
@testable import InfoNow

final class InfoNowTests: XCTestCase {

    
    @MainActor func test_newsFetch_success() async throws {
        
        MocManager.shared.addMoc(mocScenario: .success)
        let vm = NewsListViewModel()
        
        try? await Task.sleep(for: .seconds(1))
        
        XCTAssertEqual(vm.newsList.count, 100)
        XCTAssertEqual(vm.totalArticles, 100)
        
        guard let first = vm.newsList.first
        else { XCTFail("Couldn't load first result.") ; return }
        
        XCTAssertEqual(first.title, "Lola Young porte plainte contre le producteur de son tube « Messy »")
        XCTAssertEqual(first.description, "Le producteur revendiquerait indûment les crédits d’écriture de quatre des titres de la chanteuse britannique")
        XCTAssertEqual(first.content, "Lola Young ne se laissera pas flouer aussi facilement. La chanteuse britannique de 24 ans a déposé une plainte devant le tribunal de la propriété intellectuelle de Londres contre Carter Lang, lun des… [+1180 chars]")

        XCTAssertEqual(first.author, "20 Minutes avec agences")
        XCTAssertEqual(first.publishedAt, "2025-10-11T11:02:36Z")
        XCTAssertEqual(first.source.name, "20 Minutes")
        XCTAssertEqual(first.url, "https://www.20minutes.fr/arts-stars/people/4178338-20251011-lola-young-porte-plainte-contre-producteur-tube-messy")
        XCTAssertEqual(first.urlToImage, "https://img.20mn.fr/7yRX_nH4TVa_TXkGbhD90Sk/1444x920_celebrities-arrive-at-the-brit-awards-2025-at-intercontinental-hotel-london-featuring-lola-young-where-london-united-kingdom-when-01-mar-2025-credit-cover-images")
        XCTAssertTrue(vm.newsListViewState == .loaded)
    }
    
    @MainActor func test_searchResult_emptyResult() async throws {
        
        MocManager.shared.addMoc(mocScenario: .empty)
        let vm = NewsListViewModel()
        
        try? await Task.sleep(for: .seconds(1))
        
        XCTAssertEqual(vm.newsList.count, 0)
        XCTAssertEqual(vm.totalArticles, 0)
        
        XCTAssertTrue(vm.newsListViewState == .empty)
        
    }
    
    @MainActor func test_searchResult_serverError() async throws {
        MocManager.shared.addMoc(mocScenario: .serverError)
        
        let vm = NewsListViewModel()
        
        try? await Task.sleep(for: .seconds(1))
        
        XCTAssertTrue(vm.newsListViewState == .error)
    }
    
    @MainActor func test_open_and_close_article() async throws {
        
        MocManager.shared.addMoc(mocScenario: .success)
        
        let vm = NewsListViewModel()
        
        try? await Task.sleep(for: .seconds(1))
        
        guard let first = vm.newsList.first
        else { XCTFail("Couldn't load first result.") ; return }
        
        vm.selectArticle(article: first)
        XCTAssertNotNil(vm.selectedArticle)
        
        vm.selectedArticle = nil
        XCTAssertNil(vm.selectedArticle)
        
    }

}
