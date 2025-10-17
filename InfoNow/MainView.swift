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
    
    var body: some View {
        switch viewModel.newsListViewState {
        case .loading:
            loadingView
        case .loaded:
            VStack {
                HStack {
                    Text("TX_0008")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String.localizedStringWithFormat(NSLocalizedString("TX_0007", comment: "... articles"), "\(viewModel.totalArticles)"))
                        .font(.caption)
                }
                .foregroundStyle(Color.secondary)
                .padding()
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
            }
            .environmentObject(viewModel)
            .onChange(of: viewModel.selectedArticle) { oldValue, newValue in
                if newValue != nil {
                    self.openDetailView = true
                }
            }
            .refreshable {
                // Pull to refrech
                viewModel.loadNews()
            }
            .fullScreenCover(isPresented: $openDetailView) {
                NewsDetail(isOpen: $openDetailView)
                    .environmentObject(viewModel)
            }
            .mocMenu(mocEscapeAction: {viewModel.loadNews()})
        case .empty:
            emptyOrErroView(localizedTitre: "TX_0010")
        case .error:
            emptyOrErroView(localizedTitre: "TX_0011")
        }
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
                    viewModel.loadNews()
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
        .mocMenu(mocEscapeAction: {viewModel.loadNews()})
        
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
    }
    
}

struct RotationEffect: ViewModifier {
    @State var rotationAngle = 0.0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
            .onDisappear {
                rotationAngle = 0.0
            }
    }
}
extension View {
    
    func customRotationEffect() -> some View {
        modifier(RotationEffect())
    }
    
}


#Preview {
    MainView()
}
