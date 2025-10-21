//
//  NewsList.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI

struct NewsList: View {

    @Environment(NewsListViewModel.self) var viewModel
    
    @State var currentOrientation: UIDeviceOrientation = .portrait

    var body: some View {
        List(viewModel.newsList) {article in
            NewsListUniversalCell(
                article: article,
                isIpadView: false,
                imageFrameSize: UIDevice().isIpad ? 380 : UIScreen.main.bounds.width-10
            )
        }
        .id(currentOrientation)
        .frame(width: UIDevice().isIpad ? 400 : nil)
        .listStyle(.plain)
        .padding(.top)
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in

            currentOrientation = UIDevice.current.orientation
        }
    }
}


struct NewsListIpad: View {

    enum ViewOrientation {
        static let landscape = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        static let portrait = [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    @Environment(NewsListViewModel.self) var viewModel

    @State private var gridCellSize: CGFloat = (UIScreen.main.bounds.width / 2) - 10
    @State private var gridConfiguration = ViewOrientation.portrait

    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: gridConfiguration, spacing: 50) {
                ForEach(viewModel.newsList) { article in
                    NewsListUniversalCell(
                        article: article,
                        isIpadView: true,
                        imageFrameSize: gridCellSize)
                    .accessibilityIdentifier("\(article.title ?? "pas de titre")") // only work in moc enviroment
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

    @Environment(NewsListViewModel.self) var viewModel

    var article: Article
    var isIpadView: Bool

    var imageFrameSize: CGFloat

    var body: some View {
        let url = URL(string: article.urlToImage ?? "")
        
        VStack(alignment: isIpadView ? .center : .leading) {
            if let url {
                ImageView(url: url,
                          frameWidth: isIpadView ? imageFrameSize : imageFrameSize * 0.9,
                          frameHeight: imageFrameSize / 2,
                          isIpadView: isIpadView
                )
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
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.selectArticle(article: article)
        }
    }
}

extension NewsListUniversalCell {
    
    var emptyView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.clear)
                .frame(width:isIpadView ? imageFrameSize : imageFrameSize*0.9 , height: isIpadView ? imageFrameSize/2 : imageFrameSize/3)

            Image(systemName: "newspaper")
                .resizable()
                .frame(width:35, height: 35)
        }
    }
    
}

#Preview {
    NewsListIpad().environment(NewsListViewModel())
}


#Preview {
    NewsList().environment(NewsListViewModel())
}
