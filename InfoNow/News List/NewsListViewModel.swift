//
//  NewsListViewModel.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import Foundation
import SwiftUI
internal import Combine

class NewsListViewModel: ObservableObject {
    
    private var networking = NetworkService.shered
    
    @Published var newsListViewState: NewsListViewState = .loaded
    @Published var newsList: [Article] = []
    @Published var selectedArticle: Article? = nil
    
    @Published var searchSope: String = ""
    @Published var currentLoadNewsType: LoadNewsTipe = .all
    
    var totalArticles: Int {
        self.newsList.count
    }
    
    init() {
        self.loadNews()
    }
    
    public func loadNews(type: LoadNewsTipe = .all) {
        // Save current network type to allow future pull-to-refresh
        self.currentLoadNewsType = type
        
        // Reset the search scope
        if type != .search && self.searchSope.count>0 {
            self.searchSope = ""
        } else {
            // When the type is 'searching', clear the news list to allow displaying the loading view state
            self.newsList.removeAll()
        }
        
        // Only display the loading view state if the newsList is empty
        if self.totalArticles > 0 {
            self.newsListViewState = .loading
        }
        
        Task {
            do {
                let data: Articles?
                // Perform network request based on the selected type
                switch type {
                case .top:
                    data = try await self.networking.fetchTopNews()
                case .all:
                    data = try await self.networking.fetchAllNews()
                case .search:
                    data = try await self.networking.fetchNewsWithSearch(scope: self.searchSope)
                }
                
                self.newsList = data?.articles ?? []
                
                // Handle the view state according to the result
                guard self.totalArticles > 0 else {self.newsListViewState = .empty; return}
                self.newsListViewState = .loaded
            } catch {
                self.newsList.removeAll()
                self.newsListViewState = .error
            }
        }
    }
    
    public func selectArticle(article: Article) {
        self.selectedArticle = article
    }
    
}


enum NewsListViewState {
    case loading, loaded, empty, error
}
enum LoadNewsTipe {
    case top, all, search
}
