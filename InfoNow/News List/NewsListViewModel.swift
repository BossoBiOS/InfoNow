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
    
    var totalArticles: Int {
        self.newsList.count
    }
    
    init() {
        loadNews()
    }
    
    public func loadNews() {
        if self.totalArticles > 0 {
            self.newsListViewState = .loading
        }
        Task {
            do {
                let data = try await self.networking.fetchNews()
                self.newsList = data?.articles ?? []
                guard self.totalArticles > 0 else {self.newsListViewState = .empty; return}
                self.newsListViewState = .loaded
            } catch {
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
