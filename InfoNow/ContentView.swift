//
//  ContentView.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @ObservedObject var viewModel = NewsListViewModel()

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var isOpenDetailView: Bool = false
    var body: some View {
        if UIDevice().isIpad {
            // IPAD SCREEN
            if horizontalSizeClass == .regular {
                // plain ecran
            } else {
                // Affichage Ipad croped
            }
        } else {
            // IPHONE SCREEN
            NewsList()
                .environmentObject(viewModel)
                .onChange(of: viewModel.selectedArticle) { oldValue, newValue in
                    if newValue != nil {
                        self.isOpenDetailView = true
                    }
                }
                .fullScreenCover(isPresented: $isOpenDetailView) {
                    NewsDetail(isOpen: $isOpenDetailView)
                        .environmentObject(viewModel)
                }
        }
    }
}


#Preview {
    ContentView()
}
