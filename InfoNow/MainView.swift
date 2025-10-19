//
//  ContentView.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI
import CoreData

struct MainView: View {

    @ObservedObject private var viewModel = NewsListViewModel()

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @State private var openDetailView: Bool = false
    @State private var openSearchView: Bool = false
    
    var body: some View {
        VStack {
            self.toolBar
            
            switch viewModel.newsListViewState {
            case .loading:
                loadingView
            case .loaded:
                if UIDevice().isIpad {
                    // IPAD SCREEN
                    if horizontalSizeClass == .regular {
                        NewsListIpad()
                    } else {
                        NewsList()
                    }
                } else {
                    // IPHONE SCREEN
                    NewsList()
                }
            case .empty:
                self.emptyOrErroView(localizedTitre: "TX_0010")
            case .error:
                self.emptyOrErroView(localizedTitre: "TX_0011")
            }
        }
        .environmentObject(viewModel)
        .onChange(of: viewModel.selectedArticle) { oldValue, newValue in
            if newValue != nil {
                self.openDetailView = true
            }
        }
        .refreshable {
            // Pull to refrech
            viewModel.loadNews(type: viewModel.currentLoadNewsType)
        }
        .fullScreenCover(isPresented: $openDetailView) {
            NewsDetail(isOpen: $openDetailView)
                .environmentObject(viewModel)
        }
        .mocMenu(mocEscapeAction: {viewModel.loadNews()})
    }
}

extension MainView {
    
    @ViewBuilder func emptyOrErroView(localizedTitre: LocalizedStringKey) -> some View {
        ZStack {
            VStack {
                Text(localizedTitre)
                    .font(.title)
                    .multilineTextAlignment(.center)
                Button {
                    viewModel.loadNews(type: viewModel.currentLoadNewsType)
                } label: {
                    Text("TX_0012")
                        .padding()
                        .font(.headline)
                        .foregroundStyle(Color.black)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.green.opacity(0.4)))
                }
            }.padding()
            
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder var loadingView: some View {
        ZStack {
            VStack {
                Text("TX_0009")
                Image(systemName: "newspaper")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .customRotationEffect()
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder var toolBar: some View {
        HStack {
            Menu {
                VStack {
                    Button {
                        openSearchView = false
                        viewModel.loadNews()
                    } label: {
                        Text("TX_0008")
                    }
                    .accessibilityIdentifier("menu_item_00")
                    Button {
                        openSearchView = false
                        viewModel.loadNews(type: .top)
                    } label: {
                        Text("TX_0013").bold()
                    }
                    .accessibilityIdentifier("menu_item_01")
                    Button {
                        openSearchView = true
                    } label: {
                        Text("TX_0015").bold()
                    }
                    .accessibilityIdentifier("menu_item_02")
                }
            } label: {
                Image(systemName: "filemenu.and.selection").padding(10).background(Circle().foregroundStyle(Color.blue.opacity(0.1)))
            }
            .accessibilityIdentifier("button_menu")

            if openSearchView {
                HStack {
                    Image(systemName: "text.magnifyingglass")
                        .foregroundColor(.gray)
                        .accessibilityIdentifier("image_search")
                    
                    TextField("TX_0014", text: $viewModel.searchSope)
                        .onSubmit {
                            viewModel.loadNews(type: .search)
                        }
                        .textFieldStyle(PlainTextFieldStyle())
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.search)
                        .accessibilityIdentifier("textField_search")
                    
                    
                    if !viewModel.searchSope.isEmpty {
                        Button(action: {
                            viewModel.searchSope = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .accessibilityIdentifier("clear_search_text")
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.blue.opacity(0.07)))
            } else {
                Text(viewModel.currentLoadNewsType == .all ? "TX_0008" : (viewModel.currentLoadNewsType == .top ? "TX_0016" : ""))
                    .font(.headline)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("text_titre")
                Spacer()
                Text(String.localizedStringWithFormat(NSLocalizedString("TX_0007", comment: "... articles"), "\(viewModel.totalArticles)"))
                    .font(.caption)
                    .accessibilityIdentifier("text_nbOfNews")
            }
            }
        .foregroundStyle(Color.secondary)
        .padding()
    }
    
}



#Preview {
    MainView()
}
