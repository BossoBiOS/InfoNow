//
//  NewsList.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI

struct NewsList: View {
    @EnvironmentObject var viewModel: NewsListViewModel
    
    var body: some View {
        List(viewModel.newsList) {article in
            NewsListUniversalCell(article: article, isIpadView: false, imageFrameSize: UIScreen.main.bounds.width-15)
        }
        .listStyle(.plain)
        .frame(width: 350)
        .padding()
    }
}


struct NewsListIpad: View {
    enum ViewOrientation {
        static let landscape = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        static let portrait = [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    @EnvironmentObject var viewModel: NewsListViewModel
    
    @State private var gridCellSize: CGFloat = (UIScreen.main.bounds.width / 2) - 10
    @State private var gridConfiguration = ViewOrientation.portrait

    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: gridConfiguration,
                      spacing: 50) {
                ForEach(viewModel.newsList) { article in
                    NewsListUniversalCell(article: article, isIpadView: true, imageFrameSize: gridCellSize)
                }
            }
                      
            
        }
        .id(gridConfiguration.count) // force view to updte
        .onAppear(perform: {
                self.updateUIOnOrientationChange()
        })
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
           
            self.updateUIOnOrientationChange()
        }
    }
    
    
    private func updateUIOnOrientationChange() {
        let orientation = UIDevice.current.orientation
        
        guard orientation != .unknown else {return}
        
        DispatchQueue.main.async {
            if orientation.isLandscape {
                self.gridCellSize = (UIScreen.main.bounds.width/3.3)-10
                self.gridConfiguration = ViewOrientation.landscape
            } else {
                self.gridCellSize = (UIScreen.main.bounds.width/2)-10
                self.gridConfiguration = ViewOrientation.portrait
            }
        }
    }
}

// MARK: Universal reusable cell

struct NewsListUniversalCell: View {
    @EnvironmentObject var viewModel: NewsListViewModel
    
    var article: Article
    var isIpadView: Bool
    @State var imageFrameSize: CGFloat
    var body: some View {
        let url = URL(string: article.urlToImage ?? "")
        
        VStack(alignment: isIpadView ? .center : .leading) {
            
            if let url {
                AsyncImage(url: url) {
                    phase in
                    switch phase {
                    case .empty:
                        HStack {
                            ProgressView()
                        }
                        .frame(width:isIpadView ? imageFrameSize : imageFrameSize*0.9 , height: imageFrameSize/2)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(15)
                            .frame(width: isIpadView ? imageFrameSize : imageFrameSize*0.9 ,height: imageFrameSize/2)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)))
                    case .failure:
                        emptyView
                    @unknown default:
                        emptyView
                    }
                }
                .padding(.bottom)
            } else {
                emptyView
            }
            
            Text(article.source.name ?? "")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.secondary)
            Text(article.title ?? "")
                .font(.title2)
            Spacer()
            HStack {
                Text(article.publishedAt?.timeFormater ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                Circle()
                    .frame(width: 5)
                
                Text(String.localizedStringWithFormat(NSLocalizedString("TX_0001", comment: "author of article"), article.author  ?? ""))
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            .padding(.top)
        }
        .onTapGesture {
            viewModel.selectArticle(article: article)
        }
    }
}

extension NewsListUniversalCell {
    
    @ViewBuilder var emptyView: some View {
        ZStack {
            Rectangle().foregroundStyle(Color.clear).frame(width:isIpadView ? imageFrameSize : imageFrameSize*0.9 , height: isIpadView ? imageFrameSize/2 : imageFrameSize/3)
            Image(systemName: "newspaper")
                .resizable()
                .frame(width:35, height: 35)
        }
    }
    
}

#Preview {
    NewsListIpad().environmentObject(NewsListViewModel())
}


//#Preview {
//    NewsList().environmentObject(NewsListViewModel())
//}
