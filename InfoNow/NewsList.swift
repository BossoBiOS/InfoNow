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
            newsListCell(article: article)
        }
        .listStyle(.grouped)
        .frame(width: 350)
        .padding()
    }
}


extension NewsList {
    
    @ViewBuilder func newsListCell(article: Article) -> some View {
        
        let url = URL(string: article.urlToImage ?? "")
        
        VStack(alignment: .leading) {
            
            if let url {
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
            
            Text(article.source.name ?? "")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(Color.secondary)
            Text(article.title ?? "")
                .font(.title2)
            HStack {
                Text(article.publishedAt?.timeFormater ?? "")
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                Circle()
                    .frame(width: 5)
                Text("Par" + " " + (article.author  ?? ""))
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
            .padding(.top)
        }
        .onTapGesture {
            viewModel.selectArticle(article: article, with: nil)
        }
    }
    
}




#Preview {
    NewsList().environmentObject(NewsListViewModel())
}

extension String {
    var timeFormater: String {
        
        let isoDateFormater = ISO8601DateFormatter()
        isoDateFormater.timeZone = TimeZone(identifier: "FR")
        if let date = isoDateFormater.date(from: self) {
            if date.isToday {
                
                let duration = abs(date.timeIntervalSinceNow)
                
                let hours = duration / 3600
                let minutes = duration / 60
                
                var preFix: String!
                var stringDuration: String!
                if hours > 1 {
                    preFix = "heurs"
                    stringDuration = String(format: "%.0f", hours)
                } else {
                    preFix = "minutes"
                    stringDuration = String(format: "%.0f", minutes)
                }
                
                return "Il y a " + stringDuration + " " + preFix
            } else {
                let displayFormatter = DateFormatter()
                displayFormatter.dateStyle = .medium
                displayFormatter.timeStyle = .short
                displayFormatter.locale = .current
                
                let formatted = displayFormatter.string(from: date)
                return formatted
            }
        } else {
            return ""
        }
    }
}

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self) == calendar.startOfDay(for: Date())
    }
}
