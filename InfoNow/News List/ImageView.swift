//
//  ImageView.swift
//  InfoNow
//
//  Created by Kundius on 20/10/2025.
//

import SwiftUI

struct ImageView: View {
    
    @Environment(NewsListViewModel.self) var viewModel

    let url: String
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var isIpadView: Bool = false
    @State private var uiImage: UIImage? = nil
    @State private var failLoadImage: Bool = false

    var body: some View {
        Group {
            if uiImage == nil && !failLoadImage {
                HStack {
                    ProgressView()
                }
                .frame(width: frameWidth , height: frameHeight)
            } else if failLoadImage{
                emptyView
            } else {
                Image(uiImage: uiImage!)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(15)
                    .frame(height: frameHeight)
                    .clipShape(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                    )
            }
        }
        .task {
            do {
                let (image, error) = try await viewModel.loadImage(url: url)
                guard error == nil else {
                    failLoadImage = true
                    return
                }
                uiImage = image
            } catch {
                failLoadImage = true
            }
        }
        .padding(.bottom)
    }

    var emptyView: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(
                    Color.clear)
                .frame(
                    width: frameWidth ,
                    height: isIpadView ? frameHeight: (frameHeight * 2) / 3
                )
            
            Image(systemName: "newspaper")
                .resizable()
                .frame(width:35, height: 35)
        }
    }
}
