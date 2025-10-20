//
//  URLSessionTransport.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import Foundation

struct URLSessionTransport: APITransport {

    func send(_ requestURL: URLRequest, serverUrl: URL) async throws -> (HTTPURLResponse, Data?) {
        
        var finalRequest = requestURL
        finalRequest.url = URL(string: requestURL.url?.relativeString ?? "", relativeTo: serverUrl)

        let (data, response) = try await URLSession.shared.data(for: finalRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        return (httpResponse, data)
    }
}

protocol APITransport: Decodable {
    func send(
        _ requestURL: URLRequest,
        serverUrl: URL
    ) async throws -> (HTTPURLResponse, Data?)
}
