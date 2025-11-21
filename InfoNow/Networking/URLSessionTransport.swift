//
//  URLSessionTransport.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import Foundation
import OSLog

struct URLSessionTransport: APITransport {
    
    static let loger = Logger(subsystem: "Networking", category: "URLSessionTransport")

    func send(
        _ requestURL: URLRequest,
        serverUrl: URL? = nil,
        cache: URLCache? = nil
    ) async throws -> (HTTPURLResponse, Data?) {
        
        var finalRequest = requestURL
        finalRequest.url = URL(string: requestURL.url?.relativeString ?? "", relativeTo: serverUrl)
        
        finalRequest.cachePolicy = .returnCacheDataElseLoad
        
        if let cacheResponse = cache?.cachedResponse(for: finalRequest) {
            Self.loger.info("Load data from cache")
            
            let cachedhttpResponse = cacheResponse.response as! HTTPURLResponse
            let cachedData = cacheResponse.data
            return (cachedhttpResponse, cachedData)
        }
        
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        
        let urlSession = URLSession(configuration: config)
        urlSession.configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        let (data, response) = try await urlSession.data(for: finalRequest)
        
        Self.loger.info("Load data from url session")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        return (httpResponse, data)
    }
}

protocol APITransport: Decodable {
    func send(
        _ requestURL: URLRequest,
        serverUrl: URL?,
        cache: URLCache?
    ) async throws -> (HTTPURLResponse, Data?)
}
