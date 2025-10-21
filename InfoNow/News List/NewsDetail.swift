//
//  NewsDetail.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI

struct NewsDetail: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(NewsListViewModel.self) var viewModel

    @Binding var isOpen: Bool

    @State private var showWebView: Bool = false

    @State private var selectedNewsIndex: Int = 0

    var body: some View {
        VStack {
            Divider().foregroundStyle(Color.clear)
                .frame(height: UIDevice().isIpad ? 15 : 0)

            HStack {
                Button {
                    if showWebView {
                        withAnimation(.easeInOut) {
                            showWebView = false
                        }
                    } else {
                        isOpen = false
                    }
                } label: {
                    Image(systemName: "arrow.backward.to.line.circle")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundStyle(.black.opacity(0.8))
                }
                .accessibilityIdentifier("close_button")

                Spacer()
                
                if showWebView {
                    Button {
                        showWebView = false
                        if let url = URL(string: viewModel.selectedArticle!.url ?? "") {
                            self.openURL(url)
                        }
                    } label: {
                        Image(systemName: "safari")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    .accessibilityIdentifier("openInSafari_button")
                }
            }
            .padding(.horizontal)

            Divider()

            ZStack {
                PagedView(
                    selection: $selectedNewsIndex,
                    before: { index in index-1 },
                    after: { index in index+1 },
                    maxIndex: viewModel.totalArticles,
                    view: { index in
                        if index < 0 && index < viewModel.totalArticles {
                            EmptyView()
                        }
                        ScrollView {
                            self.detailView(article: viewModel.newsList[index])
                        }
                    })
                if showWebView {
                    WebView(url: URL(string: viewModel.selectedArticle!.url!)!, showWebView: $showWebView)
                }
            }
        }
        .onChange(of: viewModel.selectedArticle, { oldValue, newValue in
            selectedNewsIndex = viewModel.currentSelectedIndex
        })
        .onAppear {
            selectedNewsIndex = viewModel.currentSelectedIndex
        }
        .onDisappear {
            viewModel.selectedArticle = nil
        }
    }
}

extension NewsDetail {

    @ViewBuilder private func detailView(article: Article) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(article.source.name ?? "")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.secondary)

            Text(article.title ??  "")
                .font(.largeTitle)
                .bold()
            
            Text("TX_0006")
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
            +
            Text((article.author ?? ""))
                .font(.subheadline)
               
            Divider()

            HStack {
                Button {
                    withAnimation(.easeInOut) {
                        showWebView = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "link")
                            .foregroundStyle(Color.black.opacity(0.8))

                        Text("TX_0005")
                            .foregroundStyle(Color.black.opacity(0.8))
                            .fontWeight(.medium)
                            .padding(.horizontal, 5)
                    }
                    .padding(10)
                    .background(
                        Color.gray.opacity(0.2)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                    .contentShape(Rectangle())
                }
                .accessibilityIdentifier("urlLink_button")

                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            if let url = URL(string: article.urlToImage ?? "") {
                ImageView(url: url,
                          frameWidth: UIDevice().isIpad ? 380 : UIScreen.main.bounds.width-10,
                          frameHeight: 150
                )
                .contentShape(Rectangle())
                .padding(.bottom)
            }
            
            Divider()

            Group {
                Text(viewModel.selectedArticle?.description ?? "")

                Text(viewModel.selectedArticle?.content ?? "")
            }
            .multilineTextAlignment(.leading)
            .fontWeight(.medium)
        }
        .padding()
        .background(Color.gray.opacity(0.04))
    }
}

#Preview {
    @Previewable @State var isOpen: Bool = true
    NewsDetail(isOpen: $isOpen)
        .environment(NewsListViewModel())
}
