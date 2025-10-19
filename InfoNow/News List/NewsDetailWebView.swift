//
//  NewsDetailWebView.swift
//  InfoNow
//
//  Created by Stefan kund on 19/10/2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
 
    var url: URL
    
    @Binding var showWebView: Bool
 
    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        let request = URLRequest(url: url)
        wKWebView.load(request)
        return wKWebView
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
    }

}
