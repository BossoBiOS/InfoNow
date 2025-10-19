//
//  NewsDetail.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI

struct NewsDetail: View {
    
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var viewModel: NewsListViewModel
    @Binding var isOpen: Bool
    @State private var showWebView: Bool = false
    var body: some View {
        VStack {
            HStack {
                Button {
                    if showWebView {
                        showWebView = false
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
                }
            }.padding(.horizontal)
            Divider()

            ScrollView {
                self.detailView(article: viewModel.selectedArticle!)
            }
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
            HStack(spacing: .ulpOfOne) {
                
                Button {
                    showWebView = true
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
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(Color.gray.opacity(0.2))
                    )
                    
                }
                .accessibilityIdentifier("urlLink_button")
                Spacer()
                Button {
                    
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .bold()
                        .frame(width: 27, height: 35)
                        .foregroundStyle(.gray.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            
            if let url = URL(string: article.urlToImage ?? "") {
                AsyncImage(url: url) {
                    phase in
                    switch phase {
                    case .empty:
                        HStack {
                            ProgressView()
                        }
                        .frame(width:350, height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(15)
                            .frame(width:350, height: 150)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    case .failure:
                        EmptyView()
                            .frame(width:350, height: 150)
                    @unknown default:
                        EmptyView()
                    }
                }
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
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.04))
        .overlay {
            if showWebView {
                WebView(url: URL(string: article.url!)!, showWebView: $showWebView)
            }
        }
    }
}

#Preview {
    @Previewable @State var isOpen: Bool = true
    NewsDetail(isOpen: $isOpen)
        .environmentObject(NewsListViewModel())
}
