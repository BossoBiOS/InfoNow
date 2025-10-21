//
//  ImageView.swift
//  InfoNow
//
//  Created by Kundius on 20/10/2025.
//

import SwiftUI

struct ImageView: View {

    let url: URL
    var frameWidth: CGFloat
    var frameHeight: CGFloat
    var isIpadView: Bool = false

    var body: some View {
        AsyncImage(url: url) {
            phase in
            switch phase {
            case .empty:
                HStack {
                    ProgressView()
                }
                .frame(width: frameWidth , height: frameHeight)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(15)
                    .frame(height: frameHeight)
                    .clipShape(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                    )
            case .failure:
                emptyView
            @unknown default:
                emptyView
            }
        }
        .padding(.bottom)
    }

    var emptyView: some View {
        ZStack {
            Rectangle().foregroundStyle(Color.clear).frame(width: frameWidth , height: isIpadView ? frameHeight: (frameHeight * 2) / 3)

            Image(systemName: "newspaper")
                .resizable()
                .frame(width:35, height: 35)
        }
    }
}
