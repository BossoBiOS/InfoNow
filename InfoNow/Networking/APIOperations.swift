//
//  APIOperations.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import Foundation

fileprivate let apiKey = "0d2bc1697a614fd9a046a4dc1183df12"

enum APIOperations: Sendable {

    protocol Route: Sendable {
        static var domain: AvailableDomaine { get }
        static var methode: APIMethods { get }
    }

    protocol Operations {
        associatedtype Output: Decodable

        static func buildURLRequest(_ input: String?) throws -> (URLRequest)
        static func decodeResponse(_ data: Data?) async throws -> Output
    }
    
    // Generic URLRequest builder
    static func universalURLRequestBuilder<R: Route>(
        input: String?,
        route: R.Type
    ) throws -> (URLRequest) {
        let fullUrlString: String!
        
        var inputString: String = ""
        if let safeInput = input {
            inputString = safeInput
        }
        
        fullUrlString = route.domain.rawValue + inputString + "&apiKey=\(apiKey)"
        
        guard let url = URL(string: fullUrlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = route.methode.rawValue
        return (request)
    }
    
    // Generic response decoder
    static func universalResponseDecoder<T: Decodable>(
        _ data: Data?,
        type: T.Type
    ) async throws -> T {
        guard let data else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
    
    
    enum everything: Route, Operations {
        
        static var methode = APIMethods.get
        
        static var domain: AvailableDomaine = .everything_french
        
        typealias Output = Articles
        
        static func buildURLRequest(_ input: String? = nil) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: Output.self)
        }
        
    }
    
    enum search: Route, Operations {
      
        static var domain: AvailableDomaine = .search
        
        static var methode: APIMethods = .get
        
        typealias Output = Articles
    
        static func buildURLRequest(_ input: String?) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: Output.self)
        }
    }
    
    enum top: Route, Operations {
      
        static var domain: AvailableDomaine = .topHeadLine
        
        static var methode: APIMethods = .get
        
        typealias Output = Articles
    
        static func buildURLRequest(_ input: String?) throws -> (URLRequest) {
            try universalURLRequestBuilder(input: input, route: Self.self)
        }
        
        static func decodeResponse(_ data: Data?) async throws -> Output {
            try await universalResponseDecoder(data, type: Output.self)
        }
    }
    
    
}

enum AvailableDomaine: String {
    case topHeadLine = "/v2/top-headlines?country=fr&pageSize=100&page=1"
    case everything_french = "/v2/everything?language=fr&pageSize=100&domains=lemonde.fr,lefigaro.fr,20minutes.fr,leparisien.fr,france24.com&page=1"
    case search = "/v2/everything?pageSize=100&page=1&q="
}

enum APIMethods: String {
    case get = "GET"
    case post = "POST"
}
